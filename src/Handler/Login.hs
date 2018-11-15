{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
module Handler.Login where

import Text.Lucius
import Text.Julius
import Import
import Prelude

widgetFooter :: Widget
widgetFooter = $(whamletFile "templates/footer.hamlet")

getLoginR :: Handler Html
getLoginR = do 
    defaultLayout $ do 
        addStylesheet $ StaticR css_bootstrap_css
        toWidgetHead $(juliusFile "templates/login.julius")
        toWidget $(luciusFile "templates/login.lucius")
        $(whamletFile "templates/login.hamlet")
