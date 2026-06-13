import os
import sys

def patch(path, old, new):
    if not os.path.exists(path):
        print(f"ERROR: File not found: {path}")
        sys.exit(1)
        
    with open(path, 'r') as f:
        content = f.read()
        
    if old not in content:
        print(f"FAILED to find pattern in {path}")
        # print(f"Looking for:\n{old}")
        sys.exit(1)
        
    with open(path, 'w') as f:
        f.write(content.replace(old, new))
    print(f"Successfully patched {path}")

# 1. Fix the model -> model_name bug
patch('subplz/models.py',
    'model = whisper.load_model(model).to(device)',
    'model = whisper.load_model(model_name).to(device)')

# 2. Fix the confusing log (using a substring approach)
# Note: The actual code has a multiline f-string with an emoji
patch('subplz/models.py',
    "f\"🖥️  We're using {device}. Results will be faster using Cuda with GPU than just CPU. Lots of RAM needed no matter what.\"",
    "f\"🖥️  We're using {device}. MLX is optimized for Apple Silicon (Metal/Neural Engine).\"")

# 3. Patch transcribe.py to remove the misleading "GPU attempts failed" warning on Mac
# (Matches the exact multiline structure)
patch('subplz/transcribe.py',
    '                elif device == "cpu":\n                    logger.warning(\n                        "🚨 GPU attempts failed. Falling back to CPU with the same model. This will be much slower."\n                    )',
    '                elif device == "cpu" and be.device == "cuda":\n                    logger.warning(\n                        "🚨 GPU attempts failed. Falling back to CPU with the same model. This will be much slower."\n                    )')

# 4. Patch transcribe.py to handle MLX backend properly in the loop
patch('subplz/transcribe.py',
    '    devices_to_try = ["cuda", "cpu"] if be.device == "cuda" else ["cpu"]',
    '    if getattr(be, "mlx", False):\n        devices_to_try = ["mlx"]\n    else:\n        devices_to_try = ["cuda", "cpu"] if be.device == "cuda" else ["cpu"]')

# 5. Fix denoiser default value
patch('subplz/cli.py',
    '"type": str, "default": "", "help": "Use stable-ts denoiser"',
    '"type": str, "default": None, "help": "Use stable-ts denoiser"')
