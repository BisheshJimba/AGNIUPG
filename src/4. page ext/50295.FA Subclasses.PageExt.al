pageextension 50295 pageextension50295 extends "FA Subclasses"
{
    layout
    {

        //Unsupported feature: Property Modification (SourceExpr) on "Control 5".

        modify("Control 3")
        {
            Visible = false;
        }
        addafter("Control 5")
        {
            field("FA Class Code"; "FA Class Code")
            {
            }
            field("FA Posting Group"; Rec."FA Posting Group")
            {
            }
            field("Depreciation Book"; Rec."Depreciation Book")
            {
            }
            field("Depreciation Method"; Rec."Depreciation Method")
            {
            }
            field("Depreciation Rate"; Rec."Depreciation Rate")
            {
            }
        }
    }
}

