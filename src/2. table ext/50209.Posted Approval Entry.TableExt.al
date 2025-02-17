tableextension 50209 tableextension50209 extends "Posted Approval Entry"
{
    fields
    {

        //Unsupported feature: Property Modification (CalcFormula) on "Comment(Field 13)".

        field(10000; "Journal Template Name"; Code[10])
        {
            Caption = 'Journal Template Name';
            TableRelation = "Gen. Journal Template";
        }
        field(10001; "Journal Batch Name"; Code[10])
        {
            Caption = 'Journal Batch Name';
            TableRelation = "Gen. Journal Batch".Name WHERE(Journal Template Name=FIELD(Journal Template Name));
        }
        field(10002; "Receiver Name"; Text[250])
        {
        }
        field(10003; "Sender Name"; Text[250])
        {
        }
    }
}

