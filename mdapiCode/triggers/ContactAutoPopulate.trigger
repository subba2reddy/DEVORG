trigger ContactAutoPopulate on Case (before insert) {
	
	// Map declarations

	Map<string,case> NewCases=new Map<string,case>();
	map<string,Contact> MatchedCons=new Map<string,contact>();
	
	for(case c:trigger.new)	{
		newcases.put(c.SUPPLIEDemail,c);
	}
	
	for(contact con:[select id,name,email from contact where email in :newcases.keyset()])	{
		MatchedCons.put(con.email,con);
	}
	
	for(case c1:[select suppliedemail,Contactid from case where SuppliedEmail in :newcases.keyset()])
	{
	      if((c1.SuppliedEmail != null )&&(MatchedCons.containskey(c1.suppliedemail)))
	      {
	           c1.Contactid=MatchedCons.get(c1.suppliedemail).id;
	      }
	}
}