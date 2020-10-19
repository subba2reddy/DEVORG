trigger PropogateCaseCommentsToChildCases on CaseComment (after insert) {
	List<CaseComment> newCommentPool = new List<CaseComment>();
    Set<Id> parentIds = new Set<Id>();
    for(CaseComment cc: Trigger.New){
        parentIds.add(cc.parentId);
    }
    
    if(Trigger.isInsert && Trigger.isAfter){
        Map<Id,case> childcaseMap = new Map<Id, case>([Select id, status from Case where parentId in :parentIds]);
        for(CaseComment comment: Trigger.New){
           // for(Case childcase: [select id, status from case where parentid = :comment.ParentId]){
             //   if(childCase.status != 'Closed'){
             		Case childCase = childcaseMap.get(comment.ParentId);
                    caseComment childCaseComment = Comment.Clone();
                    childCaseComment.ParentId= childCase.id;
                    newCommentPool.add(childCaseComment);
              //  }
            //}
        }
        if(newCommentPool.size()>0){
            insert newCommentPool;
        }
    }
}