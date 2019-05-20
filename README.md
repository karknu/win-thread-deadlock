# win-thread-deadlock

A test program that triggers the https://gitlab.haskell.org/ghc/ghc/issues/14503 bug on windows.
It looks like the bug was fixed in 8.0.2 but only when not compiling with `-threaded`.

## Usage:
`stack --resolver lts-13.19 install`

Run the non-threaded version with:
`thread-deadlock-exe`

Run the threaded version with:
`nthread-deadlock-exe`

A successful run will produce:
```
client done
read 10 bytes 
canceling async
cancel done
```

and exit, a failing run will simply hang.


## Results on 64bit Windows10.

| LTS   |  GHC   | Threaded | Status |
| -----:| -----: | -------- | -------|
|  6.35	| 7.10.3 | No       | Broken |
|  6.35	| 7.10.3 | Yes      | Broken |
|  9.21	|  8.0.2 | No       | Fixed  |
|  9.21	|  8.0.2 | Yes	    | Broken |
| 11.22	|  8.2.2 | No       | Fixed  |
| 11.22	|  8.2.2 | Yes      | Broken |
| 12.14	|  8.4.3 | No       | Fixed  |
| 12.14	|  8.4.3 | Yes      | Broken |
| 12.26 |  8.4.4 | No	    | Fixed  |
| 12.26 |  8.4.4 | Yes      | Broken |
| 13.11 |  8.6.3 | No       | Fixed  |
| 13.11 |  8.6.3 | Yes      | Broken |
| 13.19 |  8.6.4 | No       | Fixed  |
| 13.19 |  8.6.4 | Yes      | Broken |
| 13.22 |  8.6.5 | No       | Fixed  |
| 13.22 |  8.6.5 | Yes      | Broken |


