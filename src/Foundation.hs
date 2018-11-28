{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE ViewPatterns #-}

module Foundation where

import Import.NoFoundation
import Database.Persist.Sql (ConnectionPool, runSqlPool)
import Yesod.Core.Types     (Logger)

data App = App
    { appSettings    :: AppSettings
    , appStatic      :: Static 
    , appConnPool    :: ConnectionPool 
    , appHttpManager :: Manager
    , appLogger      :: Logger
    }

mkYesodData "App" $(parseRoutesFile "config/routes")

instance Yesod App where
    makeLogger = return . appLogger
    isAuthorized MainOrganizadorR _ = isOrganizador
    isAuthorized MainPilotoR _ = isPiloto
    isAuthorized _ _ = return Authorized
    errorHandler (PermissionDenied msgErro) = fmap toTypedContent $ defaultLayout $ do
        setTitle "D E N I E D"
        toWidget [hamlet|
            <h1> 
                NOPE
            <img src=@{StaticR imgs_nope_jpg} height=100% width=100%>
        |]
    errorHandler other = defaultErrorHandler other
    
isOrganizador = do 
    maybeOrganizador <- lookupSession "organizador" 
    return $ case maybeOrganizador of
        Just _ -> Authorized 
        Nothing -> Unauthorized "nem" 
        
        
isPiloto = do 
    maybePiloto <- lookupSession "piloto" 
    return $ case maybePiloto of
        Just _ -> Authorized 
        Nothing -> Unauthorized "nope" 
    

type Form a = Html -> MForm Handler (FormResult a, Widget)

instance YesodPersist App where
    type YesodPersistBackend App = SqlBackend
    runDB action = do
        master <- getYesod
        runSqlPool action $ appConnPool master

instance RenderMessage App FormMessage where
    renderMessage _ _ = defaultFormMessage

instance HasHttpManager App where
    getHttpManager = appHttpManager