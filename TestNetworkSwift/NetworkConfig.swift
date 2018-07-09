//
//  NetworkConfig.swift
//  TestNetworkSwift
//
//  Created by Matvey Kravtsov on 07/07/2018.
//  Copyright © 2018 Matvey Kravtsov. All rights reserved.
//

import Network

let NetworkFrameSize = 1024
let NetworkParameters = NWParameters.udp
let NetworkPort = NWEndpoint.Port(integerLiteral: 1053)
let NetworkServiceType = "_camera._udp"
let NetworkServiceName = "Camera Live Streaming"
