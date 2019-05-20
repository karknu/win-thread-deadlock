module Socket
    ( socketTest
    ) where

import           Control.Concurrent
import           Control.Concurrent.Async
import           Data.ByteString.Lazy as BL
import qualified Network.Socket as Socket hiding (recv)
import qualified Network.Socket.ByteString.Lazy as Socket (recv, sendAll)

import           Text.Printf

socketTest :: IO ()
socketTest = Socket.withSocketsDo $ do
    client:_ <- Socket.getAddrInfo Nothing (Just "127.0.0.1") (Just "0")
    server:_ <- Socket.getAddrInfo Nothing (Just "127.0.0.1") (Just "6067")
     
    serverSocket <- Socket.socket Socket.AF_INET Socket.Stream Socket.defaultProtocol
    Socket.setSocketOption serverSocket Socket.ReuseAddr 1
    Socket.bind serverSocket (Socket.addrAddress server)
    Socket.listen serverSocket 1
    serverAsync <- async $ serverThread serverSocket

    clientSocket <- Socket.socket Socket.AF_INET Socket.Stream Socket.defaultProtocol
    Socket.connect clientSocket (Socket.addrAddress server)

    Socket.sendAll clientSocket $ BL.replicate 0xa 10
    printf "client done\n"

    -- uncomment to make the -threaded version work
    -- Socket.close clientSocket

    wait serverAsync

    return ()

  where
    serverThread sd = do
        (cd, _) <- Socket.accept sd
        readerAsync <- async $ readerThread cd
        Control.Concurrent.threadDelay 1000000
        printf "canceling async\n"
        cancel readerAsync
        printf "cancel done\n"
        return ()


    readerThread sd = do
        buf <- Socket.recv sd 100
        if BL.null buf
            then printf "null read\n" >> threadDelay 10000000
            
            else printf "read %d bytes \n" (BL.length buf) >> readerThread sd

