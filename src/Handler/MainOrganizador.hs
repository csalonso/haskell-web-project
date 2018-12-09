{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
module Handler.MainOrganizador where

import Text.Lucius
import Text.Julius
import Import
import Prelude

widgetFooter :: Widget
widgetFooter = $(whamletFile "templates/footer.hamlet")

getMainOrganizadorR :: Handler Html
getMainOrganizadorR = do 
    defaultLayout $ do 
        addStylesheet $ StaticR css_bootstrap_css
        toWidget $(luciusFile "templates/mainOrganizador.lucius")
        $(whamletFile "templates/mainOrganizador.hamlet")
        
getEditOrganizadorR :: Handler Html
getEditOrganizadorR = do 
    (widgetForm, enctype) <- generateFormPost formOrganizador
    defaultLayout $ do 
        addStylesheet $ StaticR css_bootstrap_css
        toWidget $(luciusFile "templates/editOrganizador.lucius")
        $(whamletFile "templates/editOrganizador.hamlet")        
        
formOrganizador :: Form (Organizador)
formOrganizador = renderBootstrap $ Organizador
    <$> areq textField "Nome: " Nothing
    <*> areq textField "Organizacao: " Nothing
    <*> areq textField "CNPJ: " Nothing
    <*> areq textField "Endereco: " Nothing
    <*> areq textField "Telefone: " Nothing
    
postEditOrganizadorR :: Handler Html 
postEditOrganizadorR = do 
    ((res,_),_) <- runFormPost formOrganizador
    case res of 
        FormSuccess (organizador) -> do
                runDB $ insert organizador
                redirect MainOrganizadorR
        _ -> redirect EditOrganizadorR
        
getInfoOrganizadorR :: OrganizadorId -> Handler Html
getInfoOrganizadorR oid = do 
    organizador <- runDB $ get404 oid
    defaultLayout $ do 
        toWidget $(luciusFile "templates/info-organizador.lucius")
        $(whamletFile "templates/info-organizador.hamlet")
        
        