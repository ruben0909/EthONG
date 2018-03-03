App = {
  web3Provider: null,
  contracts: {},

  init: function() {
    // Load projects.
    $.getJSON('../projects.json', function(data) {
      var petsRow = $('#petsRow');
      var petTemplate = $('#petTemplate');

      for (i = 0; i < data.length; i ++) {
        petTemplate.find('.panel-title').text(data[i].name);
        petTemplate.find('img').attr('src', data[i].picture);
        petTemplate.find('.pet-breed').text(data[i].description);

        petsRow.append(petTemplate.html());
      }
    });

    return App.initWeb3();
  },

  initWeb3: function() {

    // Is there an injected web3 instance?
    if (typeof web3 !== 'undefined') {
      App.web3Provider = web3.currentProvider;
    } else {
      // If no injected web3 instance is detected, fall back to Ganache
      App.web3Provider = new Web3.providers.HttpProvider('http://localhost:7545');
    }
    web3 = new Web3(App.web3Provider);

    return App.initContract();
  },

  initContract: function() {

    $.getJSON('Donation.json', function(data) {
      // Get the necessary contract artifact file and instantiate it with truffle-contract
      var DonateArtifact = data;
      App.contracts.Donation = TruffleContract(DonateArtifact);
    
      // Set the provider for our contract
      App.contracts.Donation.setProvider(App.web3Provider);
    
      // Use our contract to retrieve and mark the donated items
      return App.markDonated();
    });
   

    return App.bindEvents();
  },

  bindEvents: function() {
    $(document).on('click', '.btn-donate', App.handleDonate);
  },

  markDonated: function(donors, account) {
    var donationInstance;

    App.contracts.Donation.deployed().then(function(instance) {
      donationInstance = instance;

      return donationInstance.getDonors.call();
    }).then(function(donors) {
      for (i = 0; i < donors.length; i++) {
        if (donors[i] !== '0x0000000000000000000000000000000000000000') {
          $('.panel-pet').eq(i).find('button').text('Success').attr('disabled', true);
        }
      }
    }).catch(function(err) {
      console.log(err.message);
    });
  },

  handleDonate: function(event) {
    event.preventDefault();

    var projectId = parseInt($(event.target).data('id'));

    var donationInstance;

    web3.eth.getAccounts(function(error, accounts) {
      if (error) {
        console.log(error);
      }

      var account = accounts[0];

      App.contracts.Donation.deployed().then(function(instance) {
        donationInstance = instance;

        // Execute donate as a transaction by sending account
        return donationInstance.donate(projectId, {from: account});
      }).then(function(result) {
        return App.markDonated();
      }).catch(function(err) {
        console.log(err.message);
      });
    });
  }

};

$(function() {
  $(window).load(function() {
    App.init();
  });
});
