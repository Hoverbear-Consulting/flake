# Ported from https://github.com/NixOS/nixpkgs/blob/74a1793c659d09d7cf738005308b1f86c90cb59b/pkgs/development/python-modules/huggingface-hub/default.nix
# to fix `meta.mainProgram` for the time being

{ lib
, fetchFromGitHub
, python310Packages
}:

python310Packages.buildPythonPackage rec {
  pname = "huggingface-hub";
  version = "0.9.1";
  format = "setuptools";

  disabled = python310Packages.pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "huggingface";
    repo = "huggingface_hub";
    rev = "refs/tags/v${version}";
    hash = "sha256-/FUr66lj0wgmuLcwc84oHKBGzU8jFnBVMOXk7uKUpSk=";
  };

  propagatedBuildInputs = with python310Packages; [
    filelock
    packaging
    pyyaml
    requests
    ruamel-yaml
    tqdm
    typing-extensions
  ] ++ lib.optionals (pythonOlder "3.8") [
    importlib-metadata
  ];

  # Tests require network access.
  doCheck = false;

  pythonImportsCheck = [
    "huggingface_hub"
  ];

   meta = with lib; {
    mainProgram = "huggingface-cli";
    description = "Download and publish models and other files on the huggingface.co hub";
    homepage = "https://github.com/huggingface/huggingface_hub";
    changelog = "https://github.com/huggingface/huggingface_hub/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
