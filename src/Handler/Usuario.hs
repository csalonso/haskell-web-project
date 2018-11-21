{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
module Handler.Usuario where

import Text.Lucius
import Text.Julius
import Import
import Prelude

widgetFooter :: Widget
widgetFooter = $(whamletFile "templates/footer.hamlet")

formUsuario :: Form (Usuario,Text)
formUsuario = renderBootstrap $ (,) 
    <$> (Usuario 
            <$> areq textField "Nome: " Nothing
            <*> areq (selectFieldList [("Organizador" :: Text, "organizador"),("Piloto", "piloto")]) "Tipo" Nothing
            <*> areq emailField "E-mail: " Nothing
            <*> areq passwordField "Senha: " Nothing
        )
        <*> areq passwordField "Confirmacao de senha: " Nothing
        
getUsuarioR :: Handler Html
getUsuarioR = do 
    (widgetForm, enctype) <- generateFormPost formUsuario
    mensagem <- getMessage
    defaultLayout $ do 
        addStylesheet $ StaticR css_bootstrap_css
        toWidget $(luciusFile "templates/usuario.lucius")
        $(whamletFile "templates/usuario.hamlet")
    
postUsuarioR :: Handler Html 
postUsuarioR = do 
    ((res,_),_) <- runFormPost formUsuario
    case res of 
        FormSuccess (usuario,confirmacao) -> do
           if (usuarioSenha usuario == confirmacao) then do 
                runDB $ insert usuario
                redirect HomeR
           else do 
                redirect UsuarioR
        _ -> redirect UsuarioR
