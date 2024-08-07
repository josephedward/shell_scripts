#!/usr/bin/env python3

# Makes ffmpeg easier to use by accepting plain English. Usage:
# ffmpeg-english "capture video from the camera every 1 second and write it to jpg files"
# ffmpeg-english "take all of the images ending with .jpg in this directory and make a 30fps timelapse of it"


import openai
import sys
import os
import time

# Ensure you have set your OpenAI API key as an environment variable
openai.api_key = os.getenv("OPENAI_API_KEY")
client = openai.OpenAI()

def get_ffmpeg_command(task_description):
    # Call the OpenAI API with the task description
    response = client.chat.completions.create(
        model="gpt-4",
        messages=[
            {"role":"system", "content":"You are an expert in FFmpeg commands. Given the following English description of a task, you respond with the correct FFmpeg command. Do not include any other information in your response except for the command only."},
            {"role":"user", "content":task_description},
        ],
        max_tokens=150,
        temperature=0.5
    )
    command = response.choices[0].message.content.strip()
    return command

def main():
    if len(sys.argv) < 2:
        print("Usage: ffmpeg-english <task_description>", file=sys.stderr)
        sys.exit(1)
    
    task_description = " ".join(sys.argv[1:])
    ffmpeg_command = get_ffmpeg_command(task_description)

    # some basic guardrails
    assert(ffmpeg_command.startswith("ffmpeg"))
    assert(";" not in ffmpeg_command)
    assert("|" not in ffmpeg_command)

    print(f"Executing command: {ffmpeg_command} in 2 seconds (^C to cancel)")
    time.sleep(2)
    os.system(ffmpeg_command)

if __name__ == "__main__":
    main()
