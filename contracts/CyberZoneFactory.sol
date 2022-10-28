// SPDX-License-Identifier: GPL-3.0-only
pragma solidity ^0.8.7;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import {ERC721Holder} from "@openzeppelin/contracts/token/ERC721/utils/ERC721Holder.sol";
import {IERC721} from "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import {IERC721Metadata} from "@openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol";
import {IERC721Enumerable} from "@openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol";
import {ReentrancyGuard} from "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";

import {Cell} from "./Cell.sol";
import {ZombieFactory} from "./struct.sol";
import {FactoryInfo} from "./Cell.sol";


contract CyberZone {
    //	using SafeERC20 for IERC20;
    //	using SafeERC721 for IERC721;
    //	using SafeERC721 for IERC721Metadata;

    uint256 public TotalFactory;
    address Treasury;
    uint256 TreasuryRatio;
    uint256 FactoryOwnerRatio;
    uint256 denominator;

    struct SuperFactory {
        uint256 FactoryId;
        string FactoryForNFT;
        address CellAddress;
        string CellName;
        string Cellsymbol;
        uint256 CellDecimals;
        uint256 CellSupply;
        bytes32 ProveKey;
        string FileStoreAddress;
    }

    SuperFactory[] public factorys;

    constructor(address ts,uint256 tr,uint256 fr,uint256 dm) {
        TotalFactory = 0;
        Treasury=ts;
        TreasuryRatio=tr;
        FactoryOwnerRatio=fr;
        denominator=dm;

    }

    function CreateNewFactory(
        address AddressOfNFT,
        uint256 TotalNum,
        bytes32 ProveKey,
        string memory FileStoreAddress,
        string memory name,
        string memory symbol,
        uint256 totalsupply,
        uint8 decimals
    ) external payable returns(address ADD) {
        uint256 number = IERC721Enumerable(AddressOfNFT).totalSupply();
        require(number==TotalNum,"-1");
        require(ProveKey.length > 0, "aaaaaa-2");
        require(bytes(FileStoreAddress).length > 0, "aaaaaa-3");
        require(bytes(name).length > 0, "aaaaaa-4");
        require(bytes(symbol).length > 0, "aaaaaa-5");
        require(totalsupply > 0, "aaaaaa-6");
        require(decimals > 0, "aaaaaa-7");



        string memory nftname = IERC721Metadata(AddressOfNFT).name();
        


        FactoryInfo memory fi = FactoryInfo(Treasury,address(msg.sender),TreasuryRatio,FactoryOwnerRatio,denominator,ProveKey,AddressOfNFT);

        Cell  NewCell =  new Cell(name,symbol,totalsupply,decimals,fi);

        SuperFactory  memory temp =  SuperFactory(TotalFactory,nftname,address(NewCell),name,symbol,decimals,totalsupply,ProveKey,FileStoreAddress);
   
        factorys.push(temp);



        TotalFactory += 1;

        emit CreateNew(address(NewCell));

        return address(NewCell);
        
    }

    function CountFactory() external view returns (uint256 number) {
        return TotalFactory;
    }

    event CreateNew(address newadd);

}
