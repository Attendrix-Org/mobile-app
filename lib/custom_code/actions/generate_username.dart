// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/schema/enums/enums.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/actions/index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

// Automatic FlutterFlow Imports
import 'dart:math' as math;

Future<String> generateUsername(String? selectedGenre) async {
  // 1. Massive Categorized Linguistic Dictionary
  final Map<String, Map<String, List<String>>> genres = {
    'movies_series': {
      'descriptors': [
        'gotham',
        'tardis',
        'vader',
        'skywalker',
        'jedi',
        'sith',
        'avenger',
        'matrix',
        'mandalor',
        'westeros',
        'hogwarts',
        'cyberdyne',
        'basinga',
        'sherlock',
        'neo',
        'morpheus',
        'trinity',
        'boba',
        'asgard',
        'wakanda',
        'stark',
        'targaryen',
        'lanister',
        'autobot',
        'decepticon',
        'delorean',
        'mcfly',
        'kenobi',
        'yoda',
        'spock',
        'kirk',
        'starfleet',
        'enterprise',
        'halfield',
        'skynet',
        'sarah',
        'croft',
        'drake',
        'witcher',
        'geralt'
      ],
      'nouns': [
        'hunter',
        'walker',
        'runner',
        'knight',
        'lord',
        'ranger',
        'scout',
        'trooper',
        'captain',
        'commander',
        'rebel',
        'joker',
        'titan',
        'hero',
        'villain',
        'wizard',
        'witch',
        'mutant',
        'cyborg',
        'droid',
        'avenger',
        'gladiator',
        'survivor',
        'pilgrim',
        'bounty',
        'glitch',
        'specter',
        'phantom',
        'ghost',
        'shadow'
      ]
    },
    'books_literature': {
      'descriptors': [
        'arcane',
        'eldritch',
        'gandalf',
        'frodo',
        'shire',
        'mordor',
        'atreides',
        'harkonnen',
        'arrakis',
        'fable',
        'mythic',
        'ancient',
        'classic',
        'gothic',
        'orwell',
        'asimov',
        'tolkien',
        'lovecraft',
        'hemingway',
        'gatsby',
        'sherlock',
        'watson',
        'dracula',
        'franken',
        'dorian',
        'beowulf',
        'odyssey',
        'iliad',
        'valhalla',
        'camelot',
        'merlin',
        'arthur',
        'excalibur',
        'aslan',
        'narnia',
        'panem',
        'mocking',
        'olympus',
        'percy',
        'potter'
      ],
      'nouns': [
        'scribe',
        'scholar',
        'author',
        'poet',
        'bard',
        'mage',
        'warlock',
        'wizard',
        'thief',
        'assassin',
        'pilgrim',
        'voyager',
        'seeker',
        'keeper',
        'guardian',
        'weaver',
        'binder',
        'reader',
        'novelist',
        'chronicler',
        'prophet',
        'oracle',
        'druid',
        'templar',
        'crusader',
        'monk',
        'hermit',
        'sage',
        'mentor',
        'spectator'
      ]
    },
    'science': {
      'descriptors': [
        'quantum',
        'atomic',
        'cosmic',
        'stellar',
        'nebula',
        'galactic',
        'orbital',
        'kinetic',
        'magnetic',
        'sonic',
        'plasma',
        'entropy',
        'photon',
        'electron',
        'neutron',
        'proton',
        'quark',
        'boson',
        'hadron',
        'lepton',
        'gravity',
        'relativity',
        'fusion',
        'fission',
        'isotope',
        'catalyst',
        'enzyme',
        'cellular',
        'genetic',
        'hybrid',
        'aurora',
        'vortex',
        'pulsar',
        'quasar',
        'alpha',
        'beta',
        'gamma',
        'omega',
        'delta',
        'sigma'
      ],
      'nouns': [
        'chemist',
        'physicist',
        'biologist',
        'analyst',
        'theorist',
        'expert',
        'genius',
        'mind',
        'brain',
        'atom',
        'molecule',
        'element',
        'reaction',
        'formula',
        'matrix',
        'vector',
        'tensor',
        'helix',
        'spiral',
        'fractal',
        'cosmos',
        'universe',
        'galaxy',
        'planet',
        'comet',
        'asteroid',
        'meteor',
        'vacuum',
        'singularity',
        'horizon'
      ]
    },
    'engineering': {
      'descriptors': [
        'mechanical',
        'electrical',
        'civil',
        'aerospace',
        'robotic',
        'cybernetic',
        'synthetic',
        'tectonic',
        'structural',
        'hydraulic',
        'pneumatic',
        'thermal',
        'kinetic',
        'automated',
        'digital',
        'analog',
        'turbo',
        'supercharged',
        'diesel',
        'electric',
        'modular',
        'matrix',
        'vector',
        'binary',
        'logic',
        'algorithmic',
        'compiled',
        'dynamic',
        'static',
        'braced',
        'welded',
        'forged',
        'casted',
        'machined',
        'milled',
        'lathe',
        'cnc',
        'printed',
        'alloy',
        'titanium'
      ],
      'nouns': [
        'engineer',
        'mechanic',
        'builder',
        'maker',
        'creator',
        'designer',
        'architect',
        'developer',
        'programmer',
        'coder',
        'technician',
        'operator',
        'machinist',
        'forger',
        'smith',
        'artisan',
        'inventor',
        'tinkerer',
        'craftsman',
        'wright',
        'engine',
        'motor',
        'turbine',
        'rotor',
        'stator',
        'piston',
        'valve',
        'gear',
        'sprocket',
        'linkage'
      ]
    },
    'tech': {
      'descriptors': [
        'cyber',
        'nexus',
        'pixel',
        'crypto',
        'nano',
        'glitch',
        'hyper',
        'proxy',
        'macro',
        'cloud'
      ],
      'nouns': [
        'node',
        'spark',
        'link',
        'byte',
        'core',
        'vault',
        'buffer',
        'daemon',
        'packet',
        'kernel'
      ]
    },
    'gaming': {
      'descriptors': [
        'apex',
        'vortex',
        'savage',
        'toxic',
        'stealth',
        'rapid',
        'lethal',
        'wild',
        'reckless',
        'chaos'
      ],
      'nouns': [
        'shift',
        'dash',
        'loop',
        'zone',
        'track',
        'hunter',
        'slayer',
        'striker',
        'sniper',
        'beast'
      ]
    }
  };

  try {
    final random = math.Random();

    // 2. Resolve target genre safely
    String genreKey = selectedGenre?.trim().toLowerCase() ?? '';
    if (!genres.containsKey(genreKey)) {
      // Pick a random genre if none provided, empty, or mismatched
      final keys = genres.keys.toList();
      genreKey = keys[random.nextInt(keys.length)];
    }

    final currentGenre = genres[genreKey]!;
    final descriptors = currentGenre['descriptors']!;
    final nouns = currentGenre['nouns']!;

    // 3. Select structural layout format dynamically to prevent structural pattern fatigue
    String usernameBase = '';
    double structureRoll = random.nextDouble();

    if (structureRoll > 0.3) {
      // Standard Format (70%): Descriptor + Noun
      final String word1 = descriptors[random.nextInt(descriptors.length)];
      final String word2 = nouns[random.nextInt(nouns.length)];
      usernameBase = '$word1$word2';
    } else if (structureRoll > 0.1) {
      // Cross-Over Hybrid Format (20%): Mixes descriptors across genres for highly chaotic variety
      final allGenres = genres.keys.toList();
      final alternateGenreKey = allGenres[random.nextInt(allGenres.length)];
      final alternateDescriptors = genres[alternateGenreKey]!['descriptors']!;

      final String word1 =
          alternateDescriptors[random.nextInt(alternateDescriptors.length)];
      final String word2 = nouns[random.nextInt(nouns.length)];
      usernameBase = '$word1$word2';
    } else {
      // Ultra-Clean Single Word Format (10%)
      usernameBase = descriptors[random.nextInt(descriptors.length)];
    }

    // 4. Generate random numerical configurations to eliminate collisions
    String numberSuffix = '';
    double numericRoll = random.nextDouble();
    if (numericRoll > 0.6) {
      numberSuffix =
          (random.nextInt(90) + 10).toString(); // 2 Digits (e.g., 87)
    } else if (numericRoll > 0.15) {
      numberSuffix =
          (random.nextInt(900) + 100).toString(); // 3 Digits (e.g., 404)
    } else if (numericRoll > 0.05) {
      numberSuffix =
          (random.nextInt(9000) + 1000).toString(); // 4 Digits (e.g., 2026)
    } else {
      numberSuffix =
          ''; // 5% chance of a completely pristine non-numeric username
    }

    // 5. Enforce safety sanitization constraints
    String finalUsername = '$usernameBase$numberSuffix';
    finalUsername = finalUsername
        .trim()
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9_]'), '');

    // Edge Case Protection: Fallbacks for empty results
    if (finalUsername.isEmpty || finalUsername.length < 3) {
      return 'nexus_${random.nextInt(89999) + 10000}';
    }

    return finalUsername;
  } catch (e) {
    // Structural Runtime Exception Fallback
    final fallbackRandom = math.Random();
    return 'member_${fallbackRandom.nextInt(89999) + 10000}';
  }
}
// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the `</>` button on the right!
