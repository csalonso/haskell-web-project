{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
module Handler.MainPiloto where

import Text.Lucius
import Text.Julius
import Import
import Prelude

widgetFooter :: Widget
widgetFooter = $(whamletFile "templates/footer.hamlet")

getMainPilotoR :: Handler Html
getMainPilotoR = do 
    defaultLayout $ do 
        addStylesheet $ StaticR css_bootstrap_css
        toWidget $(luciusFile "templates/mainPiloto.lucius")
        $(whamletFile "templates/mainPiloto.hamlet")
        
getEditPilotoR :: Handler Html
getEditPilotoR = do 
    (widgetForm, enctype) <- generateFormPost formPiloto
    defaultLayout $ do 
        addStylesheet $ StaticR css_bootstrap_css
        toWidget $(luciusFile "templates/editPiloto.lucius")
        $(whamletFile "templates/editPiloto.hamlet")        
        
formPiloto :: Form (Piloto)
formPiloto = renderBootstrap $ Piloto
    <$> areq textField "Nome: " Nothing
    <*> areq dayField "Data de Nascimento: " Nothing
    <*> areq intField "Peso (Kg): " Nothing
    <*> areq intField "Altura (Cm): " Nothing
    
postEditPilotoR :: Handler Html 
postEditPilotoR = do 
    ((res,_),_) <- runFormPost formPiloto
    case res of 
        FormSuccess (piloto) -> do
                runDB $ insert piloto
                redirect MainPilotoR
        _ -> redirect EditPilotoR
        
    