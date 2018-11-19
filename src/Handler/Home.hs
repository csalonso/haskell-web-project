{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
module Handler.Home where

import Text.Lucius
import Text.Julius
import Import
import Prelude

widgetFooter :: Widget
widgetFooter = $(whamletFile "templates/footer.hamlet")

formLogin :: Form (Text,Text)
formLogin = renderBootstrap $ (,) 
        <$> areq emailField "E-mail: " Nothing
        <*> areq passwordField "Senha: " Nothing

getHomeR :: Handler Html
getHomeR = do 
    (widgetForm, enctype) <- generateFormPost formLogin
    mensagem <- getMessage
    defaultLayout $ do 
        addStylesheet $ StaticR css_bootstrap_css
        toWidget $(luciusFile "templates/home.lucius")
        $(whamletFile "templates/home.hamlet")
