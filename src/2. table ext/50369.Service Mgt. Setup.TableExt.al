tableextension 50369 tableextension50369 extends "Service Mgt. Setup"
{
    fields
    {
        field(33019884; "Job Card No."; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(33019885; "Claim No."; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(33019886; "Issue No."; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(33019887; Number; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(33019888; "VacancyNo."; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(33019889; "Review SMS Days"; DateFormula)
        {
        }
    }
}

