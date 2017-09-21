# iomem_hunter

An omelet-egg-hunter shellcode for Cisco IOS

This shellcode looks for parts of the second stage shellcode in `IP` packets within the `IO-Memory` of Cisco networking equipment and collects them together.

The following parameters should be passed to the shellcode:

```
r19 - start of the IO-memory region
r21 - size of shellcode
r22 - source ip
r25 - destination address (address to which the shellcode will be copied)

r20 - 0 (cur_size)
r24 - 0 (cur_ip_id)
```

## Building

To build the omelet-egg-hunter you must specify three parameters:

* `SIGNATURE` is an unique value, by this value the omelet-egg-hunter determines the first part of the shellcode. You should also place the same value at the beginning of the 2nd stage shellcode;

* `IOS_15` or `IOS_12` indicates for which `Cisco IOS` family the shellcode will build (the offset of the `IP-header` in a `Packet Data` structure depends on this);

* `COPY` is the address of the function `ios_move_handler` that copies data with invalidation of I-Cache, D-Cache. The address of this function can be found in the `Cisco IOS` image by the binary pattern `7C 00 20 AC`.

Build command:
 
```bash
> make iomem_hunter.bin -e IOS=IOS_15 -e SIGNATURE=0xC0DEC0DE -e COPY=0xAABBCCDD
```
