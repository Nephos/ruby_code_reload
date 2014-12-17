# Reload

To load or reload a loaded (via the ```reload``` function), use the following ruby code :  
```ruby
reload 'file'
```
It will only reload the file if it has change since the last reload (based on the mtime of the file)

## Known problems

