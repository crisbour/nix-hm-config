{
  programs.ssh = {
    enable = true;
    forwardAgent = true;
    matchBlocks = {
			slurmlogin1 = {
  			hostname = "in-czba-psl0001.slurm.codasip.com";
  			user = "cristian.bourceanu";
  			extraOptions = {
					GSSAPIDelegateCredentials = "yes";
				};
			};

			slurmlogin2 = {
  			hostname = "in-czba-psl0002.slurm.codasip.com";
  			user = "cristian.bourceanu";
  			extraOptions = {
					GSSAPIDelegateCredentials = "yes";
				};
			};

			vdilogin = {
  			hostname = "10.13.72.10";
  			user = "cristian.bourceanu";
			};
		};
	};
}
