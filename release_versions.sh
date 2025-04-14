#!/bin/bash

# Input arguments
release="$1"
releases="$2"
artifacts="$3"

# Convert input strings to arrays
read -ra release_array <<< "$releases"
read -ra artifact_array <<< "$artifacts"

# Sort the arrays in reverse version order
sorted_releases=($(printf "%s\n" "${release_array[@]}" | sort -Vr))
sorted_artifacts=($(printf "%s\n" "${artifact_array[@]}" | sort -Vr))

# Function to find matching artifact using array name references
find_artifact_for_release() {
  local target_release="$1"
  local -n rel_ref=$2
  local -n art_ref=$3

  local fallback=""

  echo "releases: ${rel_ref[@]}"
  echo "artifacts: ${art_ref[@]}"

  for rel in "${rel_ref[@]}"; do
    [[ "$rel" > "$target_release" ]] && continue

    for artifact in "${art_ref[@]}"; do
      if [[ "$artifact" == "$rel"* ]]; then
        echo "$rel matched"
        fallback=$artifact
        break 2
      fi
    done
  done

  if [[ -n "$fallback" ]]; then
    echo "$target_release => $fallback"
  else
    echo "$target_release => No matching artifact found"
  fi
}

# Call the function with name references
echo "Release to Artifact Mapping:"
find_artifact_for_release "$release" sorted_releases sorted_artifacts
