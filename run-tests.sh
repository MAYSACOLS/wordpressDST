#!/bin/bash

# Construire le projet et exécuter les tests
./mvnw clean test

# Vérifier le code de sortie des tests et agir en conséquence
if [ $? -ne 0 ]; then
  echo "Tests failed!"
  exit 1
else
  echo "Tests passed!"
  exit 0
fi
