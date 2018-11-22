{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
module Handler.Organizador where

import Text.Lucius
import Text.Julius
import Import
import Prelude

widgetFooter :: Widget
widgetFooter = $(whamletFile "templates/footer.hamlet")

getOrganizadorR :: Handler Html
getOrganizadorR = do 
    defaultLayout $ do 
        addStylesheet $ StaticR css_bootstrap_css
        toWidget $(luciusFile "templates/organizador.lucius")
        $(whamletFile "templates/organizador.hamlet")
    