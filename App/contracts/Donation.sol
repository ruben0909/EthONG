pragma solidity 0.4.19;

//This is a contract!
contract Donation {
    address[16] public donors;
// Define un nuevo tipo con dos campos.
    struct Doner {
        address addr;
        uint amount;
    }

    struct Project {
        address ong;
        uint fundingGoal;
        uint numDoners;
        uint amount;
        mapping (uint => Doner) doners;
    }
    
    uint numProjects;
    mapping (uint => Project) projects;

    function newProject(address beneficiary, uint goal) returns (uint projectId) {
        projectId = numProjects++; // campaignID es variable de retorno
        // Crea un nuevo struct y lo guarda en almacenamiento. Dejamos fuera el tipo mapping.
        projects[projectId] = Project(beneficiary, goal, 0, 0);
    }

    function donate(uint projectId) payable {
        Project c = projects[projectId];
        // Crea un nuevo struct de memoria temporal, inicializado con los valores dados
        // y lo copia al almacenamiento.
        // Nótese que también se puede usar Funder(msg.sender, msg.value) para inicializarlo
        c.doners[c.numDoners++] = Doner({addr: msg.sender, amount: msg.value});
        c.amount += msg.value;
    }
    
    // Retrieving the adopters
   function getDonors() public view returns (Doner[]) {
       Doner[] result;

       for(var j=0; j<numProjects;j++){
           for(var i=0; i<projects[j].numDoners;i++){
                result.push(Doner(projects[j].doners[i].addr, j));
           }           
       }      

       return result;
    }


    // Donate to project
    // function donate(uint projectId) public returns (uint) {
    //     require(projectId >= 0 && projectId <= 15);

    //     donors[projectId] = msg.sender;

    //     return projectId;
    //     }


    //     // Retrieving the donors
        //  function getDonors() public view returns (uint[]) {
        //      return projects;
        //  }
}