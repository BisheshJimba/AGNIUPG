table 33020513 "Posted Salary Line"
{
    // *PAYROLL 6.1.0 YURAN@AGILE*


    fields
    {
        field(1; "Document No."; Code[20])
        {
        }
        field(2; "Line No."; Integer)
        {
        }
        field(3; "Employee No."; Code[20])
        {
            NotBlank = true;
            TableRelation = Employee;
        }
        field(4; "Basic Salary"; Decimal)
        {
            Caption = 'Basic with Grade';
        }
        field(10; "Net Pay"; Decimal)
        {
        }
        field(11; "Taxable Income"; Decimal)
        {
            Editable = false;
        }
        field(12; "Monthly Tax"; Decimal)
        {
            Editable = false;
        }
        field(13; "Total Benefit"; Decimal)
        {
            Editable = false;
        }
        field(14; "Total Deduction"; Decimal)
        {
            Editable = false;
        }
        field(15; "Total Employer Contribution"; Decimal)
        {
            Editable = false;
        }
        field(16; "Total Tax Credit"; Decimal)
        {
        }
        field(20; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            Editable = false;
            TableRelation = "Dimension Value".Code WHERE(Global Dimension No.=CONST(1));
        }
        field(21; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            Editable = false;
            TableRelation = "Dimension Value".Code WHERE(Global Dimension No.=CONST(2));
        }
        field(22; Remarks; Text[250])
        {
        }
        field(23; "Present Days"; Decimal)
        {
        }
        field(24; "Absent Days"; Decimal)
        {
        }
        field(25; "Paid Days"; Decimal)
        {
        }
        field(26; "From Date"; Date)
        {
        }
        field(27; "To Date"; Date)
        {
        }
        field(28; Month; Option)
        {
            OptionCaption = ' ,January,February,March,April,May,June,July,August,September,October,November,December';
            OptionMembers = " ",January,February,March,April,May,June,July,August,September,October,November,December;
        }
        field(29; "Non-Payment Adjustment"; Decimal)
        {
            Description = 'for the Non beneficial; increases the annual earning';
        }
        field(30; "Last Slab (%)"; Decimal)
        {
        }
        field(31; "Remaining Amount to Cross Slab"; Decimal)
        {
            Editable = false;
        }
        field(32; "Tax Paid on First Account"; Decimal)
        {
        }
        field(33; "Tax Paid on Second Account"; Decimal)
        {
        }
        field(50; "Employee Name"; Text[50])
        {
            CalcFormula = Lookup(Employee."Full Name" WHERE(No.=FIELD(Employee No.)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(51;"Job Title";Text[100])
        {
            CalcFormula = Lookup(Employee."Job Title" WHERE (No.=FIELD(Employee No.)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(52;Gratuity;Decimal)
        {
        }
        field(53;"Gratuity TDS Payable";Decimal)
        {
        }
        field(54;"Net Gratuity";Decimal)
        {
        }
        field(60;"Nepali Year";Integer)
        {
            CalcFormula = Lookup("Eng-Nep Date"."Nepali Year" WHERE (English Date=FIELD(From Date)));
            FieldClass = FlowField;
        }
        field(61;"Nepali Month";Option)
        {
            CalcFormula = Lookup("Posted Salary Header"."Nepali Month" WHERE (No.=FIELD(Document No.)));
            FieldClass = FlowField;
            OptionCaption = ' ,Baisakh,Jestha,Asar,Shrawan,Bhadra,Ashoj,Kartik,Mangsir,Poush,Margh,Falgun,Chaitra';
            OptionMembers = " ",Baisakh,Jestha,Asar,Shrawan,Bhadra,Ashoj,Kartik,Mangsir,Poush,Margh,Falgun,Chaitra;
        }
        field(62;Invalid;Boolean)
        {
        }
        field(480;"Dimension Set ID";Integer)
        {
            Caption = 'Dimension Set ID';
            Editable = false;
            TableRelation = "Dimension Set Entry";
        }
        field(481;"SSF(1.67 %)";Decimal)
        {
        }
        field(50000;"Leave Encash Days";Decimal)
        {
        }
        field(33020500;"Variable Field 33020500";Decimal)
        {
            CaptionClass = '8,33020513,33020500';
        }
        field(33020501;"Variable Field 33020501";Decimal)
        {
            CaptionClass = '8,33020513,33020501';
        }
        field(33020502;"Variable Field 33020502";Decimal)
        {
            CaptionClass = '8,33020513,33020502';
        }
        field(33020503;"Variable Field 33020503";Decimal)
        {
            CaptionClass = '8,33020513,33020503';
        }
        field(33020504;"Variable Field 33020504";Decimal)
        {
            CaptionClass = '8,33020513,33020504';
        }
        field(33020505;"Variable Field 33020505";Decimal)
        {
            CaptionClass = '8,33020513,33020505';
        }
        field(33020506;"Variable Field 33020506";Decimal)
        {
            CaptionClass = '8,33020513,33020506';
        }
        field(33020507;"Variable Field 33020507";Decimal)
        {
            CaptionClass = '8,33020513,33020507';
        }
        field(33020508;"Variable Field 33020508";Decimal)
        {
            CaptionClass = '8,33020513,33020508';
        }
        field(33020509;"Variable Field 33020509";Decimal)
        {
            CaptionClass = '8,33020513,33020509';
        }
        field(33020510;"Variable Field 33020510";Decimal)
        {
            CaptionClass = '8,33020513,33020510';
        }
        field(33020511;"Variable Field 33020511";Decimal)
        {
            CaptionClass = '8,33020513,33020511';
        }
        field(33020512;"Variable Field 33020512";Decimal)
        {
            CaptionClass = '8,33020513,33020512';
        }
        field(33020513;"Variable Field 33020513";Decimal)
        {
            CaptionClass = '8,33020513,33020513';
        }
        field(33020514;"Variable Field 33020514";Decimal)
        {
            CaptionClass = '8,33020513,33020514';
        }
        field(33020515;"Variable Field 33020515";Decimal)
        {
            CaptionClass = '8,33020513,33020515';
        }
        field(33020516;"Variable Field 33020516";Decimal)
        {
            CaptionClass = '8,33020513,33020516';
        }
        field(33020517;"Variable Field 33020517";Decimal)
        {
            CaptionClass = '8,33020513,33020517';
        }
        field(33020518;"Variable Field 33020518";Decimal)
        {
            CaptionClass = '8,33020513,33020518';
        }
        field(33020519;"Variable Field 33020519";Decimal)
        {
            CaptionClass = '8,33020513,33020519';
        }
        field(33020520;"Variable Field 33020520";Decimal)
        {
            CaptionClass = '8,33020511,33020520';
        }
        field(33020521;"Variable Field 33020521";Decimal)
        {
            CaptionClass = '8,33020511,33020521';
        }
        field(33020522;"Variable Field 33020522";Decimal)
        {
            CaptionClass = '8,33020511,33020522';
        }
        field(33020523;"Variable Field 33020523";Decimal)
        {
            CaptionClass = '8,33020511,33020523';
        }
        field(33020524;"Variable Field 33020524";Decimal)
        {
            CaptionClass = '8,33020511,33020524';
        }
        field(33020525;"Variable Field 33020525";Decimal)
        {
            CaptionClass = '8,33020511,33020525';
        }
        field(33020526;"Variable Field 33020526";Decimal)
        {
            CaptionClass = '8,33020511,33020526';
        }
        field(33020527;"Variable Field 33020527";Decimal)
        {
            CaptionClass = '8,33020511,33020527';
        }
        field(33020528;"Variable Field 33020528";Decimal)
        {
            CaptionClass = '8,33020511,33020528';
        }
        field(33020529;"Variable Field 33020529";Decimal)
        {
            CaptionClass = '8,33020511,33020529';
        }
        field(33020530;"Variable Field 33020530";Decimal)
        {
            CaptionClass = '8,33020511,33020530';
        }
        field(33020531;"Variable Field 33020531";Decimal)
        {
            CaptionClass = '8,33020511,33020531';
        }
        field(33020532;"Variable Field 33020532";Decimal)
        {
            CaptionClass = '8,33020511,33020532';
        }
        field(33020533;"Variable Field 33020533";Decimal)
        {
            CaptionClass = '8,33020511,33020533';
        }
        field(33020534;"Variable Field 33020534";Decimal)
        {
            CaptionClass = '8,33020511,33020534';
        }
        field(33020535;"Variable Field 33020535";Decimal)
        {
            CaptionClass = '8,33020511,33020535';
        }
        field(33020536;"Variable Field 33020536";Decimal)
        {
            CaptionClass = '8,33020511,33020536';
        }
        field(33020537;"Variable Field 33020537";Decimal)
        {
            CaptionClass = '8,33020511,33020537';
        }
        field(33020538;"Variable Field 33020538";Decimal)
        {
            CaptionClass = '8,33020511,33020538';
        }
        field(33020539;"Variable Field 33020539";Decimal)
        {
            CaptionClass = '8,33020511,33020539';
        }
        field(33020540;"Variable Field 33020540";Decimal)
        {
            CaptionClass = '8,33020511,33020540';
        }
        field(33020541;Reversed;Boolean)
        {
        }
        field(33020542;"Pre Assigned No.";Code[30])
        {
        }
        field(33020543;"Tax Exceeding First Slab";Decimal)
        {
        }
    }

    keys
    {
        key(Key1;"Document No.","Line No.")
        {
            Clustered = true;
        }
        key(Key2;"Employee No.","From Date")
        {
            SumIndexFields = "Tax Paid on First Account","Tax Paid on Second Account";
        }
    }

    fieldgroups
    {
    }

    var
        DocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order"," ","Salary Plan";

    [Scope('Internal')]
    procedure ShowDimensions()
    var
        PostedDocDim: Record "480";
    begin
        /* pram
        TESTFIELD("Document No.");
        TESTFIELD("Line No.");
        PostedDocDim.SETRANGE("Table ID",DATABASE::"Posted Salary Line");
        PostedDocDim.SETRANGE("Document No.","Document No.");
        PostedDocDim.SETRANGE("Line No.","Line No.");
        PostedDocDim.SETRANGE("Dimension Set ID", "Dimension Set ID");
        PostedDocDimensions.SETTABLEVIEW(PostedDocDim);
        PostedDocDimensions.RUNMODAL;
        */

    end;
}

