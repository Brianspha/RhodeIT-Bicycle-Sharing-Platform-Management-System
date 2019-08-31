 pragma solidity >= 0.5 .0;
 // Enable the ABI v2 Coder
 pragma experimental ABIEncoderV2;

 import "../contracts/SafeMath.sol";
 /**
 *@Contract to help in the running of the Bicycle Sharing app
 @dev the ABI V2 Encoder is enabled due to the limitations of Nethereum 
  *issue- Nethereum is not able to convert from bytes32 to string which calls for the usage of the experimanatal ABI encoder
 @notice the contract is not optimised for gas because of the C# API not supporting certain web3 API calls
 */
 contract RhodeIT {

     using SafeMath
     for uint;
     /*====================*Struct section start ====================*/
     /**
     * @dev represents a student
     * @param studentNo represents a student registertation id
     * @param studentNopassword represents a student no and password (hash) used as ID on the platform
     * @param active used to check if a student exists on the system or not
     @param credit represents how much credit the student has in they account
     */
     struct Student {
         string studentNo;
         uint credit;
         bool active;
         string[] usedBicycles;
     }

     event addUserLogger(bool indexed results);
     event userExistsLogger(string indexed tHash, bool indexed results);
     event addDockingStationLogger(string indexed tHash, bool indexed results);
     event dockingStationExistsLogger(string indexed tHash, bool indexed results);
     event foundDockingStationEvent(string indexed name, string indexed latitude, string indexed longitude);

     /**
     * @dev represents a bicycle to be used on the platform
     * @param id unique identification for the current instance of the Bicycle
     @param dockedAt indicates where the bicycle is currently docked or which dockign station its docked in
     * @param userCount keeps track of the total no of students who hav used the bicycle used for iterating through
     @UserHistory
     * @param userHistory used to keep track of all students who have used the Bicycle
     * @param active indicates if instance exists or not
     @param isDocked indicates if the bicycle is docked or not
     @param index represents the index location of in the docking s
     @param features the specifications of the bicycle
     */
     struct Bicycle {
         string id;
         string dockedAt;
         uint256 userCount;
         bool active;
         bool isDocked;
         string[] userHistory;
         uint256 index;
         string features;
     }
     /**
     * @dev represents a venue to be used as a DockingStation
     * @param name the name of the docking station on campus
     @param lat position on map
     @param long position on map
     * @param active indicates if instance exists or not
     */
     struct VenueLocation {
         string name;
         string longitude;
         string latitude;
         bool active;
     }

     /**
     * @dev represents a DockingStation on Campus
       @param id represents the index of the Dockingstation on the Global mapping of DockingStations
     * @param venueLocation represents the DockingStation on Campus
     * @param availableBicycles stores AvailableBicycles on the DockingStation
     * @param active indicates is instace exists or not
     *@param availableBicyclesKeys used to store all bicycle keys of available bicycles at the current docking station
     */
     struct DockingStation {
         string id;
         VenueLocation dockingStationInformation;
         uint256 count;
         string[] availableBicyclesKeys;
         mapping(string => Bicycle) availableBicycles;
         bool active;
     }


     /*====================*Contract variable section start ====================*/
     /**
      * @dev stores all registered students on platform
      */
     mapping(string => Student) Students;
     string[] registeredStudentsKeys;
     /**
      *@dev stores all registed docking DockingStations on the platform
      */
     mapping(string => DockingStation) dockingStations;
     string[] dockingStationKeys;
     /**
      * @dev keeps track of the total no of registered DockingStations
      */
     /**
      * @dev keeps track of the total no of registered students
      */

     /**
      *@dev represents the owner of the platform
      */
     address admin;
     mapping(string => Bicycle) bicycles;
     string[] bicycleKeys;
     uint256 rideCost = 10;

     /*====================*modifiers section start ====================*/

     modifier onlyAdmin() {
         require(msg.sender == admin, "Only admin allowed to call this function");
         _;
     }

     /*====================*Contract function section start ====================*/
     //@dev called when contract is created
     constructor() public {
         /**
          *@dev ensure that address is valid
          */
         require(msg.sender != address(0));
         admin = msg.sender;
     }


     /**
      *@dev responsible for adding a new student on the database
      * @param studentNo represents the student identification no
      * @notice empty variable checking is done outside of the blockchain
      */
     function addUser(string memory studentNo) public returns(bool) {
         require(msg.sender != address(0), "Invalid sender address in addUser function");
         require(!Students[studentNo].active, "Student already registered");
         Students[studentNo].studentNo = studentNo;
         Students[studentNo].active = true;
         registeredStudentsKeys.push(studentNo);
         return true;
     }


     /**
      * @dev responsible for checking if a particular user exists
      * @param studentNo studentNo to verify * @notice empty variable checking is done outside of the blockchain
      * @return if exist or not
      *
      */
     function userExists(string memory studentNo) public view returns(bool) {
         return Students[studentNo].active;
     }

     function updateCredit(string memory studentNo, uint256 credit) public onlyAdmin returns(bool) {
         require(msg.sender != address(0), "Invalid sender address in updateCredit function");
         require(Students[studentNo].active, "Student not registered");
         require(credit > 0, "new credit must be greater than 0");
         Students[studentNo].credit = Students[studentNo].credit.add(credit);
         return true;
     }

     function getUsercredit(string memory studentNo) public view returns(uint256) {
         require(msg.sender != address(0), "Invalid sender address in updateCredit function");
         require(Students[studentNo].active, "Student not registered");
         return Students[studentNo].credit;
     }

     function getAllRegisteredUserKeys() onlyAdmin public view returns(string[] memory) {
         return registeredStudentsKeys;
     }

     /*====================Docking Station functions Section Start ====================*/

     /**
      * @dev responsible for adding a new docking station
      * * @notice empty variable checking is done outside of the blockchain
      */
     function registerDockingStation(string memory name, string memory latitude, string memory longitude) onlyAdmin public
     returns(bool) {
         /**
          * @dev ensure that the sender address is valid
          */
         require(msg.sender != address(0), "Invalid sender address");
         require(!dockingStations[name].active, "Docking Station already exits");
         dockingStations[name].id = name;
         dockingStations[name].dockingStationInformation.name = name;
         dockingStations[name].dockingStationInformation.longitude = longitude;
         dockingStations[name].dockingStationInformation.latitude = latitude;
         dockingStations[name].count = 0;
         dockingStationKeys.push(name);
         dockingStations[name].active = true;
         return true;
     }

     function getRegisteredDockingStationKeys() public view returns(string[] memory) {
         require(msg.sender != address(0), "Invalid sender address");
         return dockingStationKeys;
     }
     /**
      *@dev responsible for checking if a docking is registered
      * @param name the DockingStation name to search for
      * @notice empty variable checking is done outside of the blockchain
      */
     function dockingStationExists(string memory name) onlyAdmin public
     view returns(bool) {
         require(msg.sender != address(0), "Invalid sender address");
         return dockingStations[name].active;
     }

     function getDockingStation(string memory stationName) public view returns(string memory name, string memory latitude, string memory longitude) {
         require(msg.sender != address(0), "Invalid sender address");
         name = dockingStations[stationName].dockingStationInformation.name;
         latitude = dockingStations[stationName].dockingStationInformation.latitude;
         longitude = dockingStations[stationName].dockingStationInformation.longitude;
     }

     /*====================Bicycle functions Section Start ====================*/

     /**
     @dev responsible for adding a new bicycle
     @param bicycleId the unique identifer given to the bicycle
     */
     function registerNewBicycle(string memory bicycleId, string memory features, string memory dockingStation) public onlyAdmin returns(bool) {
         require(!bicycles[bicycleId].active, "Bicycle already added");
         require(dockingStations[dockingStation].active, "Docking station doesnt exist");
         require(!dockingStations[dockingStation].availableBicycles[bicycleId].active, "Bicycle already docked");
         bicycles[bicycleId].id = bicycleId;
         bicycles[bicycleId].dockedAt = dockingStation;
         bicycles[bicycleId].userCount = 0;
         bicycles[bicycleId].active = true;
         bicycles[bicycleId].isDocked = true;
         bicycles[bicycleId].features = features;
         bicycles[bicycleId].index = dockingStations[dockingStation].count;
         bicycleKeys.push(bicycleId);
         dockingStations[dockingStation].availableBicyclesKeys.push(bicycleId);
         dockingStations[dockingStation].availableBicycles[bicycleId] = bicycles[bicycleId];
         dockingStations[dockingStation].count++;
         return true;
     }

     function getBicycle(string memory bicycleId) public view returns(string memory, string memory, string memory) {
         require(msg.sender != address(0), "Invalid sender address");
         require(bicycles[bicycleId].active, "Bicycle doesnt exist");
         return (bicycles[bicycleId].id, bicycles[bicycleId].dockedAt, bicycles[bicycleId].features);
     }

     function rentBicycle(string memory studentNo, string memory bicycleId, string memory dockingStation) public returns(bool) {
         require(msg.sender != address(0), "Invalid sender address");
         require(Students[studentNo].active, "Student not reigistered");
         require(dockingStations[dockingStation].active, "Docking station doesnt exist");
         require(dockingStations[dockingStation].availableBicycles[bicycleId].isDocked, "Bicycle not docked");
         require(dockingStations[dockingStation].availableBicycles[bicycleId].active, "Bicycle not registered");
         require(Students[studentNo].credit >= rideCost, "Insufficient cost to borrow a bicycle");
         Students[studentNo].credit.sub(rideCost);
         dockingStations[dockingStation].availableBicycles[bicycleId].isDocked = false;
         delete dockingStations[dockingStation].availableBicyclesKeys[bicycles[bicycleId].index];
         delete dockingStations[dockingStation].availableBicycles[bicycleId];
         dockingStations[dockingStation].availableBicyclesKeys.length--;
         bicycles[bicycleId].userHistory.push(studentNo);
         bicycles[bicycleId].isDocked = false;
         return true;
     }

     function dockBicycle(string memory studentNo, string memory bicycleId, string memory dockingStation) public returns(bool) {
         require(msg.sender != address(0), "Invalid sender address");
         require(Students[studentNo].active, "Student not registered");
         require(bicycles[bicycleId].active, "Bicycle not registered");
         require(!bicycles[bicycleId].isDocked, "Bicycle already docked");
         require(dockingStations[dockingStation].active, "Docking station doesnt exist");
         bicycles[bicycleId].userHistory.push(studentNo);
         dockingStations[dockingStation].availableBicyclesKeys.push(bicycleId);
         bicycles[bicycleId].isDocked = true;
         bicycles[bicycleId].dockedAt = dockingStation;
         dockingStations[dockingStation].availableBicycles[bicycleId] = bicycles[bicycleId];
         return true;
     }

     function bicycleDocked(string memory bicycleId) public view returns(bool) {
         require(msg.sender != address(0), "Invalid sender address");
         require(bicycles[bicycleId].active, "Bicycle not registered");
         return bicycles[bicycleId].isDocked;
     }
 }