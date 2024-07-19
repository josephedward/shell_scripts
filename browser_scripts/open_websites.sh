#!/bin/bash

websites=("https://www.openai.com", "https://www.deeplearning.ai", "https://www.coursera.org", "https://www.udemy.com")

for website in "${websites[@]}"
do
    /Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome  --new-tab "$website" &
done