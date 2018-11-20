{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
module Handler.Main where

import Text.Lucius
import Text.Julius
import Import
import Prelude

widgetFooter :: Widget
widgetFooter = $(whamletFile "templates/footer.hamlet")

getMainR :: Handler Html
getMainR = do 
    defaultLayout $ do 
        addStylesheet $ StaticR css_bootstrap_css
        toWidget $(luciusFile "templates/main.lucius")
        $(whamletFile "templates/main.hamlet")