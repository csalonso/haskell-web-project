{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
module Handler.Corrida where

import Text.Lucius
import Text.Julius
import Import
import Prelude
import Data.Time

widgetFooter :: Widget
widgetFooter = $(whamletFile "templates/footer.hamlet")

formCorrida :: Form (Corrida)
formCorrida = renderBootstrap $ Corrida
    <$> areq textField "Nome da Corrida: " Nothing
    <*> areq dayField "Data: " Nothing
    <*> areq timeFieldTypeTime "Hora: " Nothing
    <*> areq textField "Localização: " Nothing
    <*> areq (selectFieldList [("Sol" :: Text, "sol"),("Chuva", "chuva")]) "Condição Climática" Nothing
    <*> areq textField "Pista: " Nothing
    <*> areq intField "Duração: " Nothing

getCorridaR :: Handler Html
getCorridaR = do 
    (widgetForm, enctype) <- generateFormPost formCorrida
    mensagem <- getMessage
    defaultLayout $ do 
        addStylesheet $ StaticR css_bootstrap_css
        toWidget $(luciusFile "templates/corrida.lucius")
        $(whamletFile "templates/corrida.hamlet")
        
getListaCorridaR :: Handler Html
getListaCorridaR = do
    corridas <- runDB $ selectList [] [Asc CorridaNome]
    defaultLayout $ do
        addStylesheet $ StaticR css_bootstrap_css
        toWidget $(luciusFile "templates/lista-corridas.lucius")
        $(whamletFile "templates/lista-corridas.hamlet")
        
        
postCorridaR :: Handler Html 
postCorridaR = do 
    ((res,_),_) <- runFormPost formCorrida
    case res of 
        FormSuccess (corrida) -> do
                runDB $ insert corrida
                redirect MainOrganizadorR
        _ -> redirect CorridaR
        
getInfoR :: CorridaId -> Handler Html
getInfoR cid = do 
    corrida <- runDB $ get404 cid
    defaultLayout $ do 
        toWidget $(luciusFile "templates/info.lucius")
        $(whamletFile "templates/info.hamlet")