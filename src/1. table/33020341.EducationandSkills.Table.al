table 33020341 "Education and Skills"
{

    fields
    {
        field(1; "Application No."; Code[20])
        {
            TableRelation = Application.No.;
        }
        field(2; "School Name"; Text[80])
        {
        }
        field(3; "School Country"; Text[50])
        {
        }
        field(4; "Sch. Graduation Date"; Date)
        {

            trigger OnValidate()
            begin
                "Sch. Additional Grad. Date" := STPLSysMgmt.getNepaliDate("Sch. Graduation Date");
            end;
        }
        field(5; "Sch. Additional Grad. Date"; Code[20])
        {
            CaptionClass = STPLSysMgmt.getVariableField(33020341, 5);
        }
        field(6; "School Description"; Text[150])
        {
        }
        field(7; "Int. College/Univ."; Text[80])
        {
        }
        field(8; "Int. Country"; Text[50])
        {
        }
        field(9; "Int. Grad. Date"; Date)
        {
        }
        field(10; "Int. Add. Grad. Date"; Code[20])
        {
            CaptionClass = STPLSysMgmt.getVariableField(33020341, 10);
        }
        field(11; "Int. Description"; Text[150])
        {
        }
        field(12; "Bach. College/Univ."; Text[80])
        {
        }
        field(13; "Bach. Country"; Text[50])
        {
        }
        field(14; "Bach. Grad. Date"; Date)
        {
        }
        field(15; "Bach. Add. Grad. Date"; Code[20])
        {
            CaptionClass = STPLSysMgmt.getVariableField(33020341, 15);
        }
        field(16; "Bach. Description"; Text[150])
        {
        }
        field(17; "Mst. College/Univ."; Text[80])
        {
        }
        field(18; "Mst. Country"; Text[50])
        {
        }
        field(19; "Mst. Grad. Date"; Date)
        {
        }
        field(20; "Mst. Add. Grad. Date"; Code[20])
        {
            CaptionClass = STPLSysMgmt.getVariableField(33020341, 20);
        }
        field(21; "Mst. Description"; Text[150])
        {
        }
        field(22; "PHd. College/Univ."; Text[80])
        {
        }
        field(23; "PHd. Country"; Text[50])
        {
        }
        field(24; "PHd. Grad. Date"; Date)
        {
        }
        field(25; "PHd. Add. Grad. Date"; Code[20])
        {
            CaptionClass = STPLSysMgmt.getVariableField(33020341, 25);
        }
        field(26; "PHd. Description"; Text[150])
        {
        }
        field(27; "ES Variable Field 1"; Text[50])
        {
            CaptionClass = STPLSysMgmt.getVariableField(33020341, 27);
        }
        field(28; "ES Variable Field 2"; Text[50])
        {
            CaptionClass = STPLSysMgmt.getVariableField(33020341, 28);
        }
        field(29; "ES Variable Field 3"; Text[50])
        {
            CaptionClass = STPLSysMgmt.getVariableField(33020341, 29);
        }
        field(30; "ES Variable Field 4"; Text[50])
        {
            CaptionClass = STPLSysMgmt.getVariableField(33020341, 30);
        }
        field(31; "ES Variable Field 5"; Text[50])
        {
            CaptionClass = STPLSysMgmt.getVariableField(33020341, 31);
        }
        field(32; "ES Variable Field 6"; Text[50])
        {
            CaptionClass = STPLSysMgmt.getVariableField(33020341, 32);
        }
        field(33; "ES Variable Field 7"; Text[50])
        {
            CaptionClass = STPLSysMgmt.getVariableField(33020341, 33);
        }
        field(34; "ES Variable Field 8"; Text[50])
        {
            CaptionClass = STPLSysMgmt.getVariableField(33020341, 34);
        }
        field(35; "ES Variable Field 9"; Text[50])
        {
            CaptionClass = STPLSysMgmt.getVariableField(33020341, 35);
        }
        field(36; "ES Variable Field 10"; Text[50])
        {
            CaptionClass = STPLSysMgmt.getVariableField(33020341, 36);
        }
        field(37; "Bach. Subject"; Text[50])
        {
            Caption = 'Major';
        }
        field(38; "Mst. Subject"; Text[50])
        {
            Caption = 'Major';
        }
        field(39; "PHd. Subject"; Text[50])
        {
            Caption = 'Major';
        }
    }

    keys
    {
        key(Key1; "Application No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        STPLSysMgmt: Codeunit "50000";
}

