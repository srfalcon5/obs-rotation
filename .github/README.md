## Installing
1. Create a Group and place what should be rotated through within it.
2. Select Tools -> Scripts -> Add -> `rotation.lua` to add the script.
3. Adjust the end time and interval to your needs— the default is what is used by the Falcon 5.

## FAQ
**Q: Why doesn't it rotate exactly every X seconds?**<br>
**A:** Overhead is added on purpose so that a scene cannot be repeated. Additional overhead is present in the nature of Lua-based OBS scripts, but not to a relevant or significant degree. To reduce or remove this overhead, allow greater options by filling groups with more sources.

## Acknowledgements
Created by [Matt Ronchetto](https://maatt.fr) for the class of 2023 and beyond.
