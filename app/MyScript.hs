module MyScript (script) where

import Marvin.Prelude hiding (logInfo, logError)
import Logger (logInfo, logError)
import Data.Text (Text, pack)
import Marvin.Adapter.Slack.RTM
import Data.ByteString.Lazy.Internal.ByteString

script :: IsAdapter a => ScriptInit a
script = defineScript "my-script" $ do
        hear (r [CaseInsensitive] ".*") $ do
            message <- getMessage
            match <- getMatch
            topic <- getTopic
            user <- getUser
            logInfo $(isT "message: #{message}, match: #{match}, topic: #{topic}")
            logInfo $(isT "user: #{encode user :: ByteString}")
        respond "hello" $ do -- react to direct commands
            user <- getUser
            username <- getUsername user
            reply $(isL "Hello to you too, #{username}")
