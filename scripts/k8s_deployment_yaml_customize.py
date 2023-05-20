import yaml
import os


env = os.getenv("APP_ENV")
bot_image = os.getenv("BOT_IMAGE_NAME")
worker_image = os.getenv("WORKER_IMAGE_NAME")
file_to_save = f'{os.getenv("K8S_DEPLOYMENT_FILE")}'
file_to_open = f'{os.getenv("K8S_YAML_TO_EDIT")}'

with open(file_to_open) as file:
    y = yaml.safe_load(file)
    y["metadata"]["labels"]["env"] = env
    y["spec"]["selector"]["matchLabels"]["env"] = env
    y["spec"]["template"]["metadata"]["labels"]["env"] = env
    y["spec"]["template"]["spec"]["containers"][0]["env"][0]["value"] = env

    if bot_image:
        y["spec"]["template"]["spec"]["containers"][0]["image"] = bot_image
    else:
        y["spec"]["template"]["spec"]["containers"][0]["image"] = worker_image


with open(file_to_save, 'w') as deploy:
    yaml.dump(y, deploy)
