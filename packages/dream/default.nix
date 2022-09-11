/*

Before use you need to do something like this on NixOS:

```nix
hardware.opengl.extraPackages = with pkgs; [
    rocm-opencl-icd
    rocm-runtime
];
nixpkgs.config.allowUnfree = true;
```

Also, set a huggingface token:

```bash
nix run nixpkgs#python310Packages.huggingface_hub -- login
```

# Troubleshooting

It may be you need systemwide cuda support, but I did not:

```nix
nixpkgs.config.cudaSupport = true;
```

Or you can replace `propagatedBuildInputs`'s `torch` item with:

```nix
(torch.override { cudaSupport = true; })
```
*/
{ lib
, fetchFromGitHub
, python310Packages
, python310
, diffusers
}:

python310.pkgs.buildPythonApplication rec {
  pname = "dream";
  version = "0.0.1";
  format = "setuptools";

  src = ./.;

  propagatedBuildInputs = with python310Packages; [
    importlib-metadata
    pillow
    datasets
    filelock
    numpy
    torch-bin
    transformers
    diffusers
    ftfy
  ];

  # Tests require network access.
  doCheck = false;

#   pythonImportsCheck = [
#     "dream"
#   ];

   meta = with lib; {
    mainProgram = "dream";
    description = "Download and publish models and other files on the huggingface.co hub";
    homepage = "https://github.com/huggingface/huggingface_hub";
    changelog = "https://github.com/huggingface/huggingface_hub/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
