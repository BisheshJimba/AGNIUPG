pageextension 50294 pageextension50294 extends "FA Classes"
{
    actions
    {
        addfirst(creation)
        {
            action("FA Subclass")
            {
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page 5616;
                RunPageLink = FA Class Code=FIELD(Code);
                RunPageView = SORTING(Code)
                              ORDER(Ascending);
            }
        }
    }
}

