// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;
import "hardhat/console.sol";


library Types {
    struct Voter { // pemilih
        uint256 uniqueToken; 
        uint8 stateCode; // dapil
        bool isVote; // sudah voting
        uint256[] votedTo; // pemilih ini memilih siapa saja
    }

    struct Candidate { // kandidat

        string name;
        string partyShortcut;
        string partyFlag;
        uint256 nominationNumber; // nomor kandidat
        uint8 stateCode; //dapil
        uint256 votesCount; // jumlah pemilih kandidat ini
        string roleName;
    }

    struct Party { // partai
        uint256 id;
        string partyShortcut;
        string partyFlag;
        uint256 partyCount; // jumlah pemilih partai ini
    }
    

    struct Results { //hasil akhir kandidat
        string name;
        string partyShortcut;
        string partyFlag;
        uint256 voteCount;
        uint256 nominationNumber; 
        uint8 stateCode;
        string roleName;
    }

    struct Role { // posisi ( capres, dpr, dprd dan dpd
        uint256 roleId;
        string name;
        uint8 stateCode;
        uint256 roleCount;


    }
}


contract Voting {
    Types.Candidate[] public candidates;
    Types.Party[] public parties;
    Types.Role[] public roles;
    Types.Voter[] public voterss;
    mapping(uint256 => Types.Voter) voter;
    mapping(uint256 => Types.Candidate) candidate;
    mapping(uint256 => Types.Party) party;
    mapping(uint256 => Types.Role) role;
    mapping(uint256 => uint256) internal votesCount;
    mapping(uint256 => uint256) internal partyCount;
    mapping(uint256 => uint256) internal roleCount;

    uint256 chiefID;
    address electionChief;
    uint256 private votingStartTime;
    uint256 private votingEndTime;

    constructor() {
        initializeCandidateDatabase_();
        votingStartTime = 111;
        votingEndTime = 500000;
        electionChief = msg.sender;
        chiefID = uint256(123456789);
    }

    // Number of voter
    uint8 numVoters;
    uint256 counters=0;
    uint8 constant stateCodeFinal = 10;
    function increment(uint256 num)
        public
    {
        counters += num;
    }
    function getIncrement() public view returns(uint256) {
        return counters;
    }

    function getCandidateList(uint256 voterToken)
        public
        view
        returns (Types.Candidate[] memory)
    {
        Types.Voter storage voter_ = voter[voterToken];
        uint256 _politicianOfMyConstituencyLength = 0;

        for (uint256 i = 0; i < candidates.length; i++) {
            if (
                voter_.stateCode == stateCodeFinal
            ) _politicianOfMyConstituencyLength++;
        }
        Types.Candidate[] memory cc = new Types.Candidate[](
            _politicianOfMyConstituencyLength
        );

        uint256 _indx = 0;
        for (uint256 i = 0; i < candidates.length; i++) {
            if (
                voter_.stateCode == candidates[i].stateCode && candidates[i].stateCode == stateCodeFinal
            ) {
                cc[_indx] = candidates[i];
                _indx++;
            }
        }
        return cc;
    }

    function getAllCandidateList()
        public
        view
        returns (Types.Candidate[] memory)
    {

        Types.Candidate[] memory cc = new Types.Candidate[](
            candidates.length
        );

        uint256 _indx = 0;
        for (uint256 i = 0; i < candidates.length; i++) {
                cc[_indx] = candidates[i];
                _indx++;
            
        }
        return cc;
    }

        function getPartyList()
        public
        view
        returns (Types.Party[] memory)
    {        //uint256 _politicianOfMyConstituencyLength = 0;

        Types.Party[] memory cc = new Types.Party[](
            parties.length
        );

        uint256 _indx = 0;
        for (uint256 i = 0; i < parties.length; i++) {
                cc[_indx] = parties[i];
                _indx++;
            
        }
        return cc;
    }

    function getRoleList()
        public
        view
        returns (Types.Role[] memory)
    {        //uint256 _politicianOfMyConstituencyLength = 0;

        Types.Role[] memory cc = new Types.Role[](
            roles.length
        );

        uint256 _indx = 0;
        for (uint256 i = 0; i < roles.length; i++) {
                cc[_indx] = roles[i];
                _indx++;
            
        }
        return cc;
    }


    // function isVoterEligible(uint256 voterAadharNumber)
    //     public
    //     view
    //     returns (bool voterEligible_)
    // {
    //     Types.Voter storage voter_ = voter[voterAadharNumber];
    //     if (voter_.age >= 18 && voter_.isAlive) voterEligible_ = true;
    // }

    function didCurrentVoterVoted(uint256 voterToken,uint8 loop)
        public
        view
        returns (bool userVoted_, Types.Candidate[] memory candidate_)
    {
        userVoted_ = (voter[voterToken].isVote != false);
        if (userVoted_)
            //Types.Candidate[] memory candidat
            for(uint i=0;i<loop;i++){
                candidate_[i]=(candidate[voter[voterToken].votedTo[i]]);
            }
    }


    function vote(
        uint256[] memory  nominationNumbers,
        uint256 voterToken,
        uint256 currentTime_,
        uint8 stateCode
    )
        public
        votingLinesAreOpen(currentTime_)
    {

            require(voter[voterToken].isVote==false, "Error:You cannot double vote");
            require(stateCode == stateCodeFinal,"Error not same statecode");
            voter[voterToken] = Types.Voter(voterToken,stateCode,true,nominationNumbers);
            uint8 presidentCounter =0;
            uint8 wakilPresidentCounter =1;
            uint8 dprCounter = 0;
            uint8 dprdCounter = 0;
            uint8 dpdCounter = 0;

             for (uint i=0; i<nominationNumbers.length; i++){
                for(uint j=0;j<candidates.length;j++){
                if(candidates[j].nominationNumber == nominationNumbers[i]){
                        if(keccak256(abi.encodePacked(candidates[j].roleName))==keccak256("PRESIDEN")){
                            presidentCounter++;
                        }
                        if(keccak256(abi.encodePacked(candidates[j].roleName))==keccak256("DPD")){
                            dpdCounter++;
                        }
                        if(keccak256(abi.encodePacked(candidates[j].roleName))==keccak256("DPR")){
                            dprCounter++;
                        }
                        if(keccak256(abi.encodePacked(candidates[j].roleName))==keccak256("DPRD")){
                            dprdCounter++;
                        }
                        // if(keccak256(abi.encodePacked(candidates[j].roleName))==keccak256("WAKILPRESIDEN")){
                        //     wakilPresidentCounter++;
                        // }
                    }
                }

             }
              
            require(presidentCounter == 1 && wakilPresidentCounter == 1 && dpdCounter==1 && dprCounter==1 && dprdCounter==1,"Kamu memilih kandidat dengan role yang sama lebih dari satu kali");

             for (uint i=0; i<nominationNumbers.length; i++) 
            {   
               for(uint j=0;j<candidates.length;j++){
                   if(candidates[j].nominationNumber == nominationNumbers[i]){
                       candidates[j].votesCount++;
                       for(uint k=0;k<parties.length;k++){
                           if(keccak256(abi.encodePacked(candidates[j].partyShortcut))==keccak256(abi.encodePacked(parties[k].partyShortcut)) && keccak256(abi.encodePacked(candidates[j].roleName))!=keccak256("PRESIDEN")){
                               parties[k].partyCount++;
                           }
                       }
                       for(uint l=0;l<roles.length;l++){
                           if(keccak256(abi.encodePacked(candidates[j].roleName))==keccak256(abi.encodePacked(roles[l].name))){
                               roles[l].roleCount++;
                           }
                       }

                   }
               }
            }
            numVoters++;

    }

    //     function vote(uint8 candidateID,string e) public {

    //     //if false the vote will be registered
    //     require(!voters[e].voted, "Error:You cannot double vote");
        
    //     voters[e] = Voter (candidateID,true); //add the values to the mapping
    //     numVoters++;
    //     candidates[candidateID].voteCount++; //increment vote counter of candidate
        
    // }

    //function to get count of candidates

    // function getNumOfCandidates() public view returns(uint8) {
    //     return numCandidates;
    // }

    //function to get count of voters



    function getVotingEndTime() public view returns (uint256 endTime_) {
        endTime_ = votingEndTime;
    }
    

    function ping() public pure  returns (string memory x) {
        x = "blabla";
    }

    function updateVotingStartTime(uint256 startTime_, uint256 currentTime_,uint256 chiefId_)
        public
        isElectionChief(chiefId_)
    {
        require(votingStartTime > currentTime_);
        votingStartTime = startTime_;
    }

    function extendVotingTime(uint256 endTime_, uint256 currentTime_, uint256 chiefId_)
        public
        isElectionChief(chiefId_)
    {
        require(votingStartTime < currentTime_);
        require(votingEndTime > currentTime_);
        votingEndTime = endTime_;
    }


    function getResults(uint256 currentTime_)
        public
        view
        returns (Types.Results[] memory)
    {
        require(votingEndTime < currentTime_);
        Types.Results[] memory resultsList_ = new Types.Results[](
            candidates.length
        );
        for (uint256 i = 0; i < candidates.length; i++) {
            resultsList_[i] = Types.Results({
                name: candidates[i].name,
                partyShortcut: candidates[i].partyShortcut,
                partyFlag: candidates[i].partyFlag,
                nominationNumber: candidates[i].nominationNumber,
                stateCode: candidates[i].stateCode,
                voteCount: candidates[i].votesCount,
                roleName : candidate[i].roleName
            });
        }
        return resultsList_;
    }


    modifier votingLinesAreOpen(uint256 currentTime_) {
        require(currentTime_ >= votingStartTime);
        require(currentTime_ <= votingEndTime);
        _;
    }

    modifier isEligibleVote(uint256 voterToken, uint256[] memory nominationNumber_, uint8 loop) {
        Types.Voter memory voter_ = voter[voterToken];
        for (uint i=0; i<loop; i++) 
        {
            Types.Candidate memory politician_ = candidate[nominationNumber_[i]];
            require(voter_.isVote == false);
            require(
                (politician_.stateCode == voter_.stateCode)
            );
        }

        _;
    }

    modifier isElectionChief(uint256 chiefId_) {
        require(chiefId_ == chiefID);
        _;
    }

    function getNumOfVoters() public view returns(uint8) {
        return numVoters;
    }


    /**
     * Dummy data for Candidates
     * In the future, we can accept the same from construction,
     */
     
    function initializeCandidateDatabase_() internal  {
        Types.Candidate[] memory candidates_ = new Types.Candidate[](8);

        // Andhra Pradesh
        candidates_[0] = Types.Candidate({
            name: "Will dan Prabowo",
            partyShortcut: "PDIP",
            partyFlag: "https://res.cloudinary.com/dj9ttsbgm/image/upload/v1648101065/tdp_qh1rkj.png",
            nominationNumber: uint256(727477314982),
            stateCode: uint8(10),
            votesCount:uint256(0),
            roleName:"PRESIDEN"
        });
        candidates_[1] = Types.Candidate({
            name: "Ganjar Pranowo",
            partyShortcut: "PDIP",
            partyFlag: "https://res.cloudinary.com/dj9ttsbgm/image/upload/v1648101065/ysrcp_sas311.png",
            nominationNumber: uint256(835343722350),
            stateCode: uint8(10),
            votesCount:uint256(0),
            roleName:"PRESIDEN"

        });
        candidates_[2] = Types.Candidate({
            name: "Sandiaga Uno",
            partyShortcut: "GOLKAR",
            partyFlag: "https://res.cloudinary.com/dj9ttsbgm/image/upload/v1648101065/tdp_qh1rkj.png",
            nominationNumber: uint256(969039304119),
            stateCode: uint8(10),
            votesCount:uint256(0),
            roleName:"WAKILPRESIDEN"
        });
        candidates_[3] = Types.Candidate({
            name: "Anies Beswedan",
            partyShortcut: "PDIP",
            partyFlag: "https://res.cloudinary.com/dj9ttsbgm/image/upload/v1648101065/ysrcp_sas311.png",
            nominationNumber: uint256(429300763874),
            stateCode: uint8(10),
            votesCount:uint256(0),
            roleName:"WAKILPRESIDEN"

        });

        // Bihar
        candidates_[4] = Types.Candidate({
            name: "Puan Maharani",
            partyShortcut: "PDIP",
            partyFlag: "https://res.cloudinary.com/dj9ttsbgm/image/upload/v1648101064/bjp_nk4snw.png",
            nominationNumber: uint256(895363124093),
            stateCode: uint8(10),
            votesCount:uint256(0),
            roleName:"DPR"

        });
        candidates_[5] = Types.Candidate({
            name: "Fadli Zon",
            partyShortcut: "GOLKAR",
            partyFlag: "https://res.cloudinary.com/dj9ttsbgm/image/upload/v1648101064/inc_s1oqn5.png",
            nominationNumber: uint256(879824052764),
            stateCode: uint8(10),
            votesCount:uint256(0),
            roleName:"DPD"
        });
        candidates_[6] = Types.Candidate({
            name: "Fahri Hanzar",
            partyShortcut: "GOLKAR",
            partyFlag: "https://res.cloudinary.com/dj9ttsbgm/image/upload/v1648101065/1200px-RJD_Flag.svg_arrrvt.png",
            nominationNumber: uint256(994080299774),
            stateCode: uint8(10),
            votesCount:uint256(0),
            roleName:"DPRD"
        });
        candidates_[7] = Types.Candidate({
            name: "Ridwan Kamil",
            partyShortcut: "DEMOKRAT",
            partyFlag: "https://res.cloudinary.com/dj9ttsbgm/image/upload/v1648101065/aap_ujguyl.png",
            nominationNumber: uint256(807033055701),
            stateCode: uint8(10),
            votesCount:uint256(0),
            roleName:"DPRD"
        });

        for (uint256 i = 0; i < candidates_.length; i++) {
            candidate[candidates_[i].nominationNumber] = candidates_[i];
            candidates.push(candidates_[i]);
        }
         Types.Party[] memory parties_ = new Types.Party[](3);
        
            parties_[0] = Types.Party({
            id : uint256(1111),
            partyShortcut:"DEMOKRAT",
            partyFlag: "x",
            partyCount:uint256(0)
        });
            parties_[1] = Types.Party({
            id : uint256(2222),
            partyShortcut:"PDIP",
            partyFlag: "x",
            partyCount:uint256(0)
        });
            parties_[2] = Types.Party({
            id : uint256(3333),
            partyShortcut:"GOLKAR",
            partyFlag: "x",
            partyCount:uint256(0)
        });
        for (uint256 i = 0; i < parties_.length; i++) {
            party[parties_[i].id] = parties_[i];
            parties.push(parties_[i]);
        }

        Types.Role[] memory roles_ = new Types.Role[](5);
        
        roles_[0] = Types.Role({
            roleId : uint256(1111),
            name:"PRESIDEN",
            stateCode: uint8(10),
            roleCount:0

        });
        roles_[1] = Types.Role({
            roleId : uint256(2222),
            name:"WAKILPRESIDEN",
            stateCode: uint8(10),
            roleCount:0
        });
        roles_[2] = Types.Role({
            roleId : uint256(3333),
            name:"DPR",
            stateCode: uint8(10),
            roleCount:0
        });
        roles_[3] = Types.Role({
            roleId : uint256(4444),
            name:"DPD",
            stateCode: uint8(10),
            roleCount:0
        });
        roles_[4] = Types.Role({
            roleId : uint256(5555),
            name:"DPRD",
            stateCode: uint8(10),
            roleCount:0
        });
        
        for (uint256 i = 0; i < roles_.length; i++) {
            role[roles_[i].roleId] = roles_[i];
            roles.push(roles_[i]);
        }
    }
}