{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
module Handler.Cadastro where

import Text.Lucius
import Text.Julius
import Import
import Prelude

widgetFooter :: Widget
widgetFooter = $(whamletFile "templates/footer.hamlet")

getCadastroR :: Handler Html
getCadastroR = do 
    defaultLayout $ do 
        addStylesheet $ StaticR css_bootstrap_css
        toWidgetHead $(juliusFile "templates/cadastro.julius")
        toWidget $(luciusFile "templates/cadastro.lucius")
        $(whamletFile "templates/cadastro.hamlet")
