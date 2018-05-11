module Logger (logInfo, logError) where

import qualified Control.Monad.Logger as ML
import Control.Monad.IO.Class (MonadIO, liftIO)
import Marvin.Interpolate.Text (isT)
import Data.Text (Text, append, pack)
import Data.Time (getCurrentTime, utcToLocalTime, hoursToTimeZone)

getJSTTimeStamp :: IO Text
getJSTTimeStamp = fmap (pack . show) $ do
    now <- getCurrentTime
    return $ utcToLocalTime (hoursToTimeZone 9) now

stampedLog :: (MonadIO m, ML.MonadLogger m) => (Text -> m ()) -> Text -> m ()
stampedLog logger message = do
        timeStamp <- liftIO getJSTTimeStamp
        logger $(isT "[#{timeStamp}] #{message}")

logInfo :: (MonadIO m, ML.MonadLogger m) => Text -> m ()
logInfo = stampedLog $(ML.logInfo)

logError :: (MonadIO m, ML.MonadLogger m) => Text -> m ()
logError = stampedLog $(ML.logError)
