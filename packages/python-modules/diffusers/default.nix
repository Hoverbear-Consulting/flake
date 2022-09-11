{ lib
, fetchFromGitHub
, python310Packages
, cudatoolkit
}:

python310Packages.buildPythonPackage rec {
  pname = "diffusers";
  version = "0.3.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "huggingface";
    repo = "diffusers";
    rev = "refs/tags/v${version}";
    hash = "sha256-mYm7rssVoAECHwzHmyxMHOyM/hDo3KghACmBiblsG1Q=";
  };

  propagatedBuildInputs = with python310Packages; [
    importlib-metadata
    pillow
    datasets
    filelock
    numpy
    transformers
    cudatoolkit
    #torch-bin
    (torch.override { cudaSupport = true; })
  ];

  # Tests require network access.
  doCheck = false;

  pythonImportsCheck = [
    "diffusers"
  ];

   meta = with lib; {
    description = "Download and publish models and other files on the huggingface.co hub";
    homepage = "https://github.com/huggingface/huggingface_hub";
    changelog = "https://github.com/huggingface/huggingface_hub/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
