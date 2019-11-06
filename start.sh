#!/bin/bash
#
# Copyright IBM Corp All Rights Reserved
#
# SPDX-License-Identifier: Apache-2.0
#
# Exit on first error, print all commands.
echo Hello this script runs the Network

docker-compose -f docker-compose-cli.yaml down

echo stopping and removing docker containers 
echo stopping and removing docker containers 


cd channel-artifacts
rm -rf ./*
cd ../

rm -rf crypto-config

# rm -rf c./*
set -ev

# don't rewrite paths for Windows Git Bash users
# export MSYS_NO_PATHCONV=1
docker-compose -f docker-compose-cli.yaml down

../bin/cryptogen generate --config=./crypto-config.yaml

export FABRIC_CFG_PATH=$PWD

../bin/configtxgen -profile TwoOrgsOrdererGenesis -channelID byfn-sys-channel -outputBlock ./channel-artifacts/genesis.block

export CHANNEL_NAME=mychannel  && ../bin/configtxgen -profile TwoOrgsChannel - outputCreateChannelTx ./channel-artifacts/channel.tx -channelID $CHANNEL_NAME

../bin/configtxgen -profile TwoOrgsChannel -outputAnchorPeersUpdate ./channel-artifacts/HBLPKMSPanchors.tx -channelID $CHANNEL_NAME -asOrg HBLPKMSP

# ../bin/configtxgen -profile TwoOrgsChannel -outputAnchorPeersUpdate ./channel-artifacts/HBL_TURMSPanchors.tx -channelID $CHANNEL_NAME -asOrg HBL_TURMSP

# ../bin/configtxgen -profile TwoOrgsChannel -outputAnchorPeersUpdate ./channel-artifacts/HBL_GBMSPanchors.tx -channelID $CHANNEL_NAME -asOrg HBL_GBMSP

docker-compose -f docker-compose-cli.yaml down

# docker rm -f $(docker ps -aq)

docker-compose -f docker-compose-cli.yaml up

# CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/pk.hbl.com/users/Admin@pk.hbl.com/msp
# CORE_PEER_ADDRESS=peer0.pk.hbl.com:7051
# CORE_PEER_LOCALMSPID="HBLPKMSP"
# CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/pk.hbl.com/peers/peer0.pk.hbl.com/tls/ca.crt

# peer channel create -o orderer.hbl.com:7050 -c $CHANNEL_NAME -f ./channel-artifacts/channel.tx --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem

#docker-compose -f docker-compose.yaml up 

#ca.example.com orderer.example.com peer0.org1.example.com couchdb

# wait for Hyperledger Fabric to start
# incase of errors when running later commands, issue export FABRIC_START_TIMEOUT=<larger number>
#	export FABRIC_START_TIMEOUT=10
#echo ${FABRIC_START_TIMEOUT}
#	sleep ${FABRIC_START_TIMEOUT}

# Create the channel
#	docker exec -e "CORE_PEER_LOCALMSPID=Org1MSP" -e "CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/msp/users/Admin@org1.example.com/msp" peer0.org1.example.com peer channel create -o orderer.example.com:7050 -c mychannel -f /etc/hyperledger/configtx/channel.tx
# Join peer0.org1.example.com to the channel.
#	docker exec -e "CORE_PEER_LOCALMSPID=Org1MSP" -e "CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/msp/users/Admin@org1.example.com/msp" peer0.org1.example.com peer channel join -b mychannel.block

