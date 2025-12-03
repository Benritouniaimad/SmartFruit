import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:permission_handler/permission_handler.dart';

class VoiceAssistantWidget extends StatefulWidget {
  final void Function(String)? onResultReceived;

  const VoiceAssistantWidget({super.key, this.onResultReceived});

  @override
  State<VoiceAssistantWidget> createState() => _VoiceAssistantWidgetState();
}

class _VoiceAssistantWidgetState extends State<VoiceAssistantWidget> {
  final SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String _lastWords = '';
  bool _isListening = false;

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  /// Initialize speech recognition
  void _initSpeech() async {
    try {
      // On web, skip permission check as it's handled by browser
      if (!kIsWeb) {
        final permissionStatus = await Permission.microphone.request();
        if (permissionStatus.isDenied) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Permission de microphone refusée'),
                backgroundColor: Colors.red,
              ),
            );
          }
          setState(() => _speechEnabled = false);
          return;
        }
      }

      _speechEnabled = await _speechToText.initialize(
        onError: (error) {
          print('Speech recognition error: $error');
          if (mounted) {
            final msg = error.errorMsg;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(kIsWeb 
                  ? 'Erreur: Veuillez autoriser le microphone dans votre navigateur' 
                  : 'Erreur: $msg'),
                backgroundColor: Colors.orange,
                duration: const Duration(seconds: 4),
              ),
            );
          }
          setState(() => _isListening = false);
        },
        onStatus: (status) {
          print('Speech recognition status: $status');
          if (status == 'done' || status == 'notListening') {
            setState(() => _isListening = false);
          }
        },
      );

      if (!_speechEnabled && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(kIsWeb
              ? 'Veuillez autoriser le microphone dans votre navigateur'
              : 'Service de reconnaissance vocale non disponible'),
            backgroundColor: Colors.orange,
            duration: const Duration(seconds: 4),
          ),
        );
      }

      setState(() {});
    } catch (e) {
      print('Error initializing speech: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(kIsWeb
              ? 'Reconnaissance vocale nécessite HTTPS ou localhost'
              : 'Erreur d\'initialisation: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
      setState(() => _speechEnabled = false);
    }
  }

  /// Start listening for speech
  void _startListening() async {
    if (!_speechEnabled) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(kIsWeb 
              ? 'Veuillez recharger la page et autoriser le microphone'
              : 'Microphone non disponible'),
            action: SnackBarAction(
              label: 'Réessayer',
              onPressed: _initSpeech,
            ),
          ),
        );
      }
      return;
    }

    setState(() => _isListening = true);

    // Listen with options optimized for web
    await _speechToText.listen(
      onResult: _onSpeechResult,
      listenFor: const Duration(seconds: 30),
      pauseFor: const Duration(seconds: 5),
      partialResults: true,
      localeId: kIsWeb ? 'fr-FR' : 'fr_FR', // Different locale format for web
      cancelOnError: true,
      listenMode: ListenMode.confirmation,
    );

    setState(() {});
  }

  /// Stop listening for speech
  void _stopListening() async {
    await _speechToText.stop();
    setState(() => _isListening = false);
  }

  /// Callback when speech is recognized
  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _lastWords = result.recognizedWords;
    });
    // Log and call the callback if provided
    print('Reconnu (final=${result.finalResult}): $_lastWords');
    widget.onResultReceived?.call(_lastWords);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Assistant Vocal'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          if (kIsWeb)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Tooltip(
                message: 'Mode Web - Nécessite autorisation microphone',
                child: Chip(
                  label: const Text('WEB', style: TextStyle(fontSize: 10)),
                  backgroundColor: Colors.blue[100],
                ),
              ),
            ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Status indicator
            Container(
              padding: const EdgeInsets.all(16),
              child: Text(
                _isListening ? '🎤 En écoute...' : '🎤 Prêt',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Recognized words display
            Container(
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Column(
                children: [
                  const Text(
                    'Paroles reconnues:',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _isListening
                        ? _lastWords.isEmpty
                              ? 'En attente de paroles...'
                              : _lastWords
                        : _speechEnabled
                        ? _lastWords.isEmpty
                              ? 'Appuyez sur le microphone pour commencer'
                              : _lastWords
                        : kIsWeb 
                        ? 'Autorisez le microphone dans votre navigateur'
                        : 'Reconnaissance vocale non disponible',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: _isListening
                          ? Colors.blue
                          : Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),

            // Confidence indicator (if listening)
            if (_isListening)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  '⏱️ Écoute en cours... (Parlez maintenant)',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.blue,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            
            // Web-specific instructions
            if (kIsWeb && !_speechEnabled)
              Container(
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.orange[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange[200]!),
                ),
                child: Column(
                  children: [
                    Icon(Icons.info_outline, color: Colors.orange[700]),
                    const SizedBox(height: 8),
                    Text(
                      'Sur navigateur web:\n1. Autorisez le microphone quand demandé\n2. Utilisez HTTPS ou localhost\n3. Rechargez la page si nécessaire',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.orange[900],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: !_isListening
            ? _startListening
            : _stopListening,
        backgroundColor: _isListening ? Colors.red : Colors.blue,
        icon: Icon(
          _isListening ? Icons.mic : Icons.mic_none,
          size: 28,
        ),
        label: Text(
          _isListening ? 'Arrêter' : 'Écouter',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _speechToText.stop();
    super.dispose();
  }
}
