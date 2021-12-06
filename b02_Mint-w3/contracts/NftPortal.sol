pragma solidity 0.8.0;

// We need some util functions for strings.
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

import "hardhat/console.sol";

import {Base64} from "./libraries/Base64.sol";

contract GenerateNFT is ERC721URIStorage {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIds;

    // This is our SVG code. All we need to change is the word that's displayed. Everything else stays the same.
    // So, we make a baseSvg variable here that all our NFTs can use.
    string baseSvg =
        "<svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 333 333'><style>.base { fill: white; font-family: serif; font-size: 12px; }</style><rect width='100%' height='100%' fill='black' /><text x='50%' y='0%' class='base' dominant-baseline='middle' text-anchor='middle'>";

    // I create three arrays, each with their own theme of random words.
    // Pick some random funny words, names of anime characters, foods you like, whatever!
    string[] ears = ["BITTEN", "HEALTHY", "PIERCED"];
    string[] hair = ["MOHAWK", "BALD"];
    string[] eyes = [
        "BIONIC",
        "XRAY",
        "PUNCHED",
        "OPEN",
        "ALERT",
        "SUNGLASSES",
        "LASER"
    ];
    string[] nose = ["BROKEN", "NORMAL"];
    string[] mouth = ["CIGARRETS", "CLOSED"];
    string[] gloves = ["BANDAGES", "RED", "BLUE", "NONE", "BLACK"];
    string[] shorts = ["BLACK+WHITE", "BLACK+YELLOW", "GREEN", "RED"];
    string[] belt = ["YES", "NO"];
    string[] tatoos = [
        "MAORI_RIGHT",
        "MAORI_LEFT",
        "BTC",
        "ETH",
        "SKULL_RIGHT"
    ];
    string[] background = ["PURPLE", "GREEN", "BLUE", "RED"];

    constructor() ERC721("DrawAllTheThings.com", "DrawAllTheThings") {
        console.log("This is my NFT contract. Woah!");
    }
    
    // MAGICAL EVENTS.
    event NewEpicNFTMinted(address sender, uint256 tokenId);


    struct RooNFT {
        string name;
        string description;
        string image;
        string background;
        string ears;
        string hair;
        string eyes;
        string nose;
        string mouth;
        string gloves;
        string shorts;
        string belt;
        string tatoos;
    }

    function pickRandomEars(uint256 tokenId)
        public
        view
        returns (string memory)
    {
        uint256 rand = random(
            string(abi.encodePacked("EARS", Strings.toString(tokenId)))
        );
        rand = rand % ears.length;
        return ears[rand];
    }

    function pickRandomHair(uint256 tokenId)
        public
        view
        returns (string memory)
    {
        uint256 rand = random(
            string(abi.encodePacked("HAIR", Strings.toString(tokenId)))
        );
        rand = rand % hair.length;
        return hair[rand];
    }

    function pickRandomEyes(uint256 tokenId)
        public
        view
        returns (string memory)
    {
        uint256 rand = random(
            string(abi.encodePacked("EYES", Strings.toString(tokenId)))
        );
        rand = rand % eyes.length;
        return eyes[rand];
    }

    function pickRandomNose(uint256 tokenId)
        public
        view
        returns (string memory)
    {
        uint256 rand = random(
            string(abi.encodePacked("NOSE", Strings.toString(tokenId)))
        );
        rand = rand % nose.length;
        return nose[rand];
    }

    function pickRandomMouth(uint256 tokenId)
        public
        view
        returns (string memory)
    {
        uint256 rand = random(
            string(abi.encodePacked("MOUTH", Strings.toString(tokenId)))
        );
        rand = rand % mouth.length;
        return mouth[rand];
    }

    function pickRandomGloves(uint256 tokenId)
        public
        view
        returns (string memory)
    {
        uint256 rand = random(
            string(abi.encodePacked("GLOVES", Strings.toString(tokenId)))
        );
        rand = rand % gloves.length;
        return gloves[rand];
    }

    function pickRandomShorts(uint256 tokenId)
        public
        view
        returns (string memory)
    {
        uint256 rand = random(
            string(abi.encodePacked("SHORTS", Strings.toString(tokenId)))
        );
        rand = rand % shorts.length;
        return shorts[rand];
    }

    function pickRandomBelt(uint256 tokenId)
        public
        view
        returns (string memory)
    {
        uint256 rand = random(
            string(abi.encodePacked("BELT", Strings.toString(tokenId)))
        );
        rand = rand % belt.length;
        return belt[rand];
    }

    function pickRandomTatoos(uint256 tokenId)
        public
        view
        returns (string memory)
    {
        uint256 rand = random(
            string(abi.encodePacked("TATOOS", Strings.toString(tokenId)))
        );
        rand = rand % tatoos.length;
        return tatoos[rand];
    }

    function pickRandomBackground(uint256 tokenId)
        public
        view
        returns (string memory)
    {
        uint256 rand = random(
            string(abi.encodePacked("BACKGROUND", Strings.toString(tokenId)))
        );
        rand = rand % background.length;
        return background[rand];
    }

    function random(string memory input) internal pure returns (uint256) {
        return uint256(keccak256(abi.encodePacked(input)));
    }

    function makeNewNFT() public {
        uint256 newItemId = _tokenIds.current();
        RooNFT memory nft;
        nft.ears = pickRandomEars(newItemId);
        nft.hair = pickRandomHair(newItemId);
        nft.eyes = pickRandomEyes(newItemId);
        nft.nose = pickRandomNose(newItemId);
        nft.mouth = pickRandomMouth(newItemId);
        nft.gloves = pickRandomGloves(newItemId);
        nft.shorts = pickRandomShorts(newItemId);
        nft.belt = pickRandomBelt(newItemId);
        nft.tatoos = pickRandomTatoos(newItemId);
        nft.background = pickRandomBackground(newItemId);
        nft.name = "ROO";
        nft.description = "A new Combat Kangaroo";

        string memory combinedWord = string(
            abi.encodePacked(
                "<tspan x='50%' dy='15'>ears: ",
                nft.ears,
                "</tspan>",
                "<tspan x='50%' dy='15'>hair: ",
                nft.hair,
                "</tspan>",
                "<tspan x='50%' dy='15'>eyes: ",
                nft.eyes,
                "</tspan>",
                "<tspan x='50%' dy='15'>nose: ",
                nft.nose,
                "</tspan>",
                "<tspan x='50%' dy='15'>mouth: ",
                nft.mouth,
                "</tspan>",
                "<tspan x='50%' dy='15'>gloves: ",
                nft.gloves,
                "</tspan>",
                "<tspan x='50%' dy='15'>shorts: ",
                nft.shorts,
                "</tspan>",
                "<tspan x='50%' dy='15'>belt: ",
                nft.belt,
                "</tspan>",
                "<tspan x='50%' dy='15'>tatoos: ",
                nft.tatoos,
                "</tspan>",
                "<tspan x='50%' dy='15'>background: ",
                nft.background,
                "</tspan>"
            )
        );

        string memory finalSvg = string(
            abi.encodePacked(baseSvg, combinedWord, "</text></svg>")
        );

        // Get all the JSON metadata in place and base64 encode it.
        string memory json = Base64.encode(
            bytes(
                string(
                    abi.encodePacked(
                        '{"name": "',
                        // We set the title of our NFT as the generated word.
                        nft.name,
                        '","description": "',
                        // We set the title of our NFT as the generated word.
                        nft.description,
                        '", "image": "data:image/svg+xml;base64,',
                        // We add data:image/svg+xml;base64 and then append our base64 encode our svg.
                        Base64.encode(bytes(finalSvg)),
                        '"}'
                    )
                )
            )
        );
        string memory finalTokenUri = string(
            abi.encodePacked("data:application/json;base64,", json)
        );

        console.log("\n--------------------");
        console.log(finalTokenUri);
        console.log("--------------------\n");

        _safeMint(msg.sender, newItemId);

        _setTokenURI(newItemId, finalTokenUri);

        _tokenIds.increment();
        console.log(
            "An NFT w/ ID %s has been minted to %s",
            newItemId,
            msg.sender
        );

    emit NewEpicNFTMinted(msg.sender, newItemId);
    }
}