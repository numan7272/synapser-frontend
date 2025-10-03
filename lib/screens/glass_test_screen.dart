import 'package:flutter/material.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';

class GlassTestScreen extends StatelessWidget {
  const GlassTestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Dieser Code ist eine vereinfachte Version des "Blending Multiple Shapes"
    // Beispiels aus der offiziellen Dokumentation des Pakets.
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          // 1. Der Hintergrund, der durch das Glas sichtbar sein wird
          Positioned.fill(
            child: Image.network(
              'https://picsum.photos/seed/glass/800/800', // Ein zufälliges Bild
              fit: BoxFit.cover,
            ),
          ),
          // 2. Der LiquidGlassLayer, der die Animation für alle Kinder steuert
          LiquidGlassLayer(
            settings: const LiquidGlassSettings(
              thickness: 15,
              blur: 10,
              blend: 40,
              lightIntensity: 0.4,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Erstes Glas-Objekt
                LiquidGlass.inLayer(
                  // KORREKTUR: 'const' entfernt, da es keine Konstante ist.
                  shape: LiquidRoundedRectangle(
                    borderRadius: const Radius.circular(40),
                  ),
                  child: const SizedBox.square(dimension: 120),
                ),
                const SizedBox(height: 80),
                // Zweites Glas-Objekt
                LiquidGlass.inLayer(
                  // KORREKTUR: 'const' entfernt, da es keine Konstante ist.
                  shape: LiquidRoundedRectangle(
                    borderRadius: const Radius.circular(40),
                  ),
                  child: const SizedBox.square(dimension: 120),
                ),
              ],
            ),
          ),
          // Ein einfacher Text im Vordergrund
          const Positioned(
            top: 100,
            child: Text(
              'Liquid Glass Test',
              style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
