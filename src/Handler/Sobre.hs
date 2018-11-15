{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
module Handler.Sobre where

import Text.Lucius
import Text.Julius
import Import
import Prelude

widgetFooter :: Widget
widgetFooter = $(whamletFile "templates/footer.hamlet")

getSobreR :: Handler Html
getSobreR = do 
    defaultLayout $ do 
        addStylesheet $ StaticR css_bootstrap_css
        toWidgetHead $(juliusFile "templates/sobre.julius")
        toWidget $(luciusFile "templates/sobre.lucius")
        $(whamletFile "templates/sobre.hamlet")
