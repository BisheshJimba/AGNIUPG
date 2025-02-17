table 33019804 "Customer Related Entity"
{

    fields
    {
        field(1; "Related Entity No."; Code[20])
        {

            trigger OnValidate()
            begin
                IF "Related Entity No." <> xRec."Related Entity No." THEN BEGIN
                    KSKLSetup.GET;
                    KSKLSetup.TESTFIELD(KSKLSetup."Customer RE Number");
                    NoserMgmt.TestManual(KSKLSetup."Customer RE Number");
                    NoserMgmt.SetSeries("Related Entity No.");
                END;
            end;
        }
        field(2; "Related Entities Name"; Text[50])
        {
        }
        field(3; "RE Company Registration No."; Code[20])
        {
        }
        field(4; "RE Comp Reg No Issued Auth"; Text[30])
        {
            TableRelation = "Catalogues Master".Code WHERE(Type = CONST(Commercial Registration Organization));
        }
        field(5; "RE Citizenship No"; Code[20])
        {
        }
        field(6; "RE Prev Citizenship No"; Code[20])
        {
        }
        field(7; "RE Citizenship No Issued Date"; Text[15])
        {
            Description = 'In Nepali';
        }
        field(8; "RE Citizenship No Issued Distr"; Text[30])
        {
            TableRelation = "Catalogues Master".Code WHERE(Type = CONST(District));
        }
        field(9; "RE PAN"; Code[20])
        {
        }
        field(10; "RE Prev PAN"; Code[20])
        {
        }
        field(11; "RE PAN No Issued Date"; Text[15])
        {
            Description = 'Nepali';
        }
        field(12; "RE PAN No Issued District"; Text[10])
        {
            TableRelation = "Catalogues Master".Code WHERE(Type = CONST(District));
        }
        field(13; "RE Passport"; Text[30])
        {
        }
        field(14; "RE Prev passport"; Text[30])
        {
        }
        field(15; "RE Voter ID"; Code[20])
        {
        }
        field(16; "RE Prev Voter ID"; Code[20])
        {
        }
        field(17; "RE Voter ID No Issued Date"; Text[15])
        {
            Description = 'Nepali date';
        }
        field(18; "RE Gender"; Text[10])
        {
            TableRelation = "Catalogues Master".Code WHERE(Type = CONST(Gender));

            trigger OnValidate()
            begin
                TESTFIELD("Related Entities Type", '001');
            end;
        }
        field(19; "RE Entities Address Type"; Text[10])
        {
            TableRelation = "Catalogues Master".Code WHERE(Type = CONST(Address Type));
        }
        field(20; "RE Entities Address Line 1"; Text[15])
        {
        }
        field(21; "RE Entities Address Line 2"; Text[10])
        {
        }
        field(22; "RE Entities Address Line 3"; Text[10])
        {
        }
        field(23; "RE Entities Address District"; Text[10])
        {
            TableRelation = "Catalogues Master" WHERE(Type = CONST(District));
        }
        field(24; "RE Entities Addr PO Box No"; Code[20])
        {
        }
        field(25; "RE Entities Address Country"; Text[10])
        {
            TableRelation = "Catalogues Master".Code WHERE(Type = CONST(Country));
        }
        field(26; "RE Entities Telephone No 1"; Code[20])
        {

            trigger OnValidate()
            begin
                phoneNoValidation("RE Entities Telephone No 1");
            end;
        }
        field(27; "RE Entities Telephone No 2"; Code[20])
        {

            trigger OnValidate()
            begin
                phoneNoValidation("RE Entities Telephone No 2");
            end;
        }
        field(28; "Related Entities Type"; Text[10])
        {
            TableRelation = "Catalogues Master".Code WHERE(Type = CONST(Related Entity Type));
        }
        field(29; "Related Indiv Nationality"; Text[10])
        {
            TableRelation = "Catalogues Master" WHERE(Type = CONST(Country));
        }
        field(30; "Related Indiv Mobile No"; Code[15])
        {

            trigger OnValidate()
            begin
                phoneNoValidation("Related Indiv Mobile No");
            end;
        }
        field(31; "RE Entities Email Address"; Text[30])
        {
        }
        field(32; "BR RE Type"; Text[30])
        {
            TableRelation = "Catalogues Master".Code WHERE(Type = CONST(Related Entity Type));
        }
        field(33; "BR RE Name"; Text[50])
        {
        }
        field(34; "BR RE DOB/Date of Regd"; Date)
        {
        }
        field(35; "BR RE Comp Regd No"; Text[30])
        {
        }
        field(36; "BR RE Comp Regd No Issud Auth"; Text[30])
        {
            TableRelation = "Catalogues Master".Code WHERE(Type = CONST(Commercial Registration Organization));
        }
        field(37; "BR RE Citizenship No"; Text[30])
        {
        }
        field(38; "BR RE Prev Citizenship No"; Text[30])
        {
        }
        field(39; "BR RE Citizenship No Issd Date"; Text[15])
        {
        }
        field(40; "BR RE Citizenship No Issd Dist"; Text[15])
        {
            TableRelation = "Catalogues Master" WHERE(Type = CONST(District));
        }
        field(41; "BR RE PAN"; Text[30])
        {
        }
        field(42; "BR RE Prev PAN"; Text[30])
        {
        }
        field(43; "BR RE PAN No Issud Date"; Text[15])
        {
            Description = 'nepali';
        }
        field(44; "BR RE PAN Issued District"; Text[10])
        {
            TableRelation = "Catalogues Master" WHERE(Type = CONST(District));
        }
        field(45; "BR RE Passport"; Text[30])
        {
        }
        field(46; "BR RE Prev Passport"; Text[15])
        {
        }
        field(47; "BR RE Passport No Expiry Date"; Date)
        {
        }
        field(48; "BR RE Voter ID"; Code[10])
        {
        }
        field(49; "BR RE Prev Voter ID"; Code[20])
        {
        }
        field(50; "BR RE Voter ID No Issued Date"; Date)
        {
        }
        field(51; "BR RE Ind Emb Regd No"; Text[30])
        {
        }
        field(52; "BR RE Ind Emb Reg No Issd Date"; Date)
        {
        }
        field(53; "BR RE Gender"; Text[30])
        {
            TableRelation = "Catalogues Master".Code WHERE(Type = CONST(Gender));
        }
        field(54; "BR RE Percenage of Control"; Decimal)
        {
        }
        field(55; "BR RE Date of Leaving"; Date)
        {
        }
        field(56; "BR RE Father Name"; Text[30])
        {
        }
        field(57; "BR RE Grand Father Name"; Text[30])
        {
        }
        field(58; "BR RE Spouse 1 Name"; Text[30])
        {
        }
        field(59; "BR RE Spouse 2 Name"; Text[30])
        {
        }
        field(60; "BR RE Mother Name"; Text[30])
        {
        }
        field(61; "BR Nationality"; Text[10])
        {
            TableRelation = "Catalogues Master" WHERE(Type = CONST(Country));
        }
        field(62; "BR RE Address Type"; Text[30])
        {
            TableRelation = "Catalogues Master".Code WHERE(Type = CONST(Address Type));
        }
        field(63; "BR RE Address Line 1"; Text[30])
        {
        }
        field(64; "BR RE Address Line 2"; Text[30])
        {
        }
        field(65; "BR RE Address Line 3"; Text[30])
        {
        }
        field(66; "BR RE District"; Text[30])
        {
            TableRelation = "Catalogues Master".Code WHERE(Type = CONST(District));
        }
        field(67; "BR RE PO BOX"; Text[30])
        {
        }
        field(68; "BR RE Country"; Text[30])
        {
            TableRelation = "Catalogues Master".Code WHERE(Type = CONST(Country));
        }
        field(69; "BR RE Telephone No 1"; Code[20])
        {

            trigger OnValidate()
            begin
                phoneNoValidation("BR RE Telephone No 1");
            end;
        }
        field(70; "BR RE Telephone No 2"; Code[20])
        {

            trigger OnValidate()
            begin
                phoneNoValidation("BR RE Telephone No 2");
            end;
        }
        field(71; "BR RE Mobile No"; Code[20])
        {
        }
        field(72; "BR RE Fax1"; Text[30])
        {
        }
        field(73; "BR RE Fax2"; Text[30])
        {
        }
        field(74; "BR RE Email"; Text[30])
        {
        }
        field(75; "Valuator Entity Type"; Text[30])
        {
            TableRelation = "Catalogues Master".Code WHERE(Type = CONST(Related Entity Type));
        }
        field(76; "Valuator Entities Name"; Text[30])
        {
        }
        field(77; "VE DOB/Comp Regd Date"; Date)
        {
        }
        field(78; "VE Comp Regd No"; Code[20])
        {
        }
        field(79; "VE Comp Regd No Issud Auth"; Text[50])
        {
            TableRelation = "Catalogues Master".Code WHERE(Type = CONST(Commercial Registration Organization));
        }
        field(80; "VE Citizenship No"; Text[50])
        {
        }
        field(81; "VE Prev Citizenship No"; Text[50])
        {
        }
        field(82; "VE Citizenship No Issud Date"; Text[15])
        {
            Description = 'Nepali';
        }
        field(83; "VE Citizenship No Issud Distr"; Text[50])
        {
            TableRelation = "Catalogues Master".Code WHERE(Type = CONST(District));
        }
        field(84; "VE PAN"; Text[30])
        {
        }
        field(85; "VE Prev PAN"; Text[30])
        {
        }
        field(86; "VE PAN No Issued Date"; Text[15])
        {
            Description = 'Nepali';
        }
        field(87; "VE PAN No Issued Dist"; Text[30])
        {
            TableRelation = "Catalogues Master".Code WHERE(Type = CONST(District));
        }
        field(88; Type; Option)
        {
            OptionCaption = ' ,Valuator Entity,Relation Entity,Valuator Relationship';
            OptionMembers = " ","Valuator Entity","Relation Entity","Valuator Relationship";
        }
        field(89; "VE Passport"; Text[30])
        {
        }
        field(90; "VE Prev Passport"; Text[30])
        {
        }
        field(91; "VE Passport No Expiry Date"; Date)
        {
            Description = 'Not Nepali';
        }
        field(92; "VE Voter ID"; Code[20])
        {
        }
        field(93; "VE prev Voter ID"; Code[20])
        {
        }
        field(94; "VE voter ID No Issued Date"; Text[15])
        {
            Description = 'Nepli';
        }
        field(95; "VE Ind Emb Regd No"; Text[20])
        {
        }
        field(96; "VE Ind Emb Regd No Issud Date"; Date)
        {
        }
        field(97; "VE Gender"; Text[10])
        {
            TableRelation = "Catalogues Master".Code WHERE(Type = CONST(Gender));
        }
        field(98; "VE Father Name"; Text[30])
        {
        }
        field(99; "VE Grand Father Name"; Text[30])
        {
        }
        field(100; "VE Spouse 1 Name"; Text[30])
        {
        }
        field(101; "VE Spouse 2 Name"; Text[30])
        {
        }
        field(102; "VE Mother Name"; Text[30])
        {
        }
        field(103; "VE Address Type"; Text[30])
        {
            TableRelation = "Catalogues Master".Code WHERE(Type = CONST(Address Type));
        }
        field(104; "VE Address Line1"; Text[30])
        {
        }
        field(105; "VE Address Line2"; Text[30])
        {
        }
        field(106; "VE Address Lne3"; Text[30])
        {
        }
        field(107; "VE Address District"; Text[30])
        {
            TableRelation = "Catalogues Master".Code WHERE(Type = CONST(District));
        }
        field(108; "VE Address PO Box"; Text[30])
        {
        }
        field(109; "VE Address Country"; Text[30])
        {
        }
        field(110; "VE Telephone Number1"; Code[20])
        {

            trigger OnValidate()
            begin
                phoneNoValidation("VE Telephone Number1");
            end;
        }
        field(111; "VE Telephone Number2"; Code[20])
        {

            trigger OnValidate()
            begin
                phoneNoValidation("VE Telephone Number2");
            end;
        }
        field(112; "VE Mobile Number"; Code[20])
        {
        }
        field(113; "VE Fax1"; Text[30])
        {
        }
        field(114; "VE Fax2"; Text[30])
        {
        }
        field(115; "VE Email"; Text[30])
        {
        }
        field(116; "Valuator Reltn Entity Type"; Text[30])
        {
            TableRelation = "Catalogues Master".Code WHERE(Type = CONST(Related Entity Type));
        }
        field(117; "VR Name"; Text[30])
        {
        }
        field(118; "VR DOB/Date of Regd"; Date)
        {
        }
        field(119; "VR BE Comp Regd No"; Code[20])
        {
        }
        field(120; "VR BE Comp Regd No Issud Auth"; Text[30])
        {
            TableRelation = "Catalogues Master".Code WHERE(Type = CONST(Commercial Registration Organization));
        }
        field(121; "Valuator Indiv Reltn CitizenNo"; Text[30])
        {
        }
        field(122; "VRE Prev Citizenship No"; Text[30])
        {
        }
        field(123; "VRE Citizenship No Issud Date"; Date)
        {
        }
        field(124; "VRE Citizenship No Issud Dist"; Text[30])
        {
            TableRelation = "Catalogues Master".Code WHERE(Type = CONST(District));
        }
        field(125; "VRE PAN"; Text[20])
        {
        }
        field(126; "VRE Prev PAN"; Text[20])
        {
        }
        field(127; "VRE PAN No Issud Date"; Date)
        {
        }
        field(128; "VRE BE PAN issud District"; Text[30])
        {
            TableRelation = "Catalogues Master".Code WHERE(Type = CONST(District));
        }
        field(129; "VRE Passport"; Text[30])
        {
        }
        field(130; "VRE Prev Passport"; Text[30])
        {
        }
        field(131; "VRE Passport No Exp Date"; Date)
        {
        }
        field(132; "VRE Voter ID"; Text[30])
        {
        }
        field(133; "VRE Prev Voter ID"; Text[30])
        {
        }
        field(134; "VRE Voter ID No Issud Date"; Date)
        {
        }
        field(135; "VRE Ind Emb Regd No"; Text[30])
        {
        }
        field(136; "VRE Ind Emb Regd No Issd Date"; Date)
        {
        }
        field(137; "VR Gender"; Text[10])
        {
            TableRelation = "Catalogues Master".Code WHERE(Type = CONST(Gender));
        }
        field(138; "VR Percentage of control"; Decimal)
        {
        }
        field(139; "VR Date of Leaving"; Date)
        {
        }
        field(140; "VR Father Name"; Text[30])
        {
        }
        field(141; "VR Grand Father Name"; Text[20])
        {
        }
        field(142; "VR Spouse1 Name"; Text[20])
        {
        }
        field(143; "Vr Spouse2 Name"; Text[20])
        {
        }
        field(144; "VR Mother Name"; Text[20])
        {
        }
        field(145; "VR Address Type"; Text[15])
        {
            TableRelation = "Catalogues Master".Code WHERE(Type = CONST(Address Type));
        }
        field(146; "VR Address Line1"; Text[15])
        {
        }
        field(147; "VR Address Line2"; Text[15])
        {
        }
        field(148; "VR Address Line3"; Text[15])
        {
        }
        field(149; "VR District"; Text[15])
        {
            TableRelation = "Catalogues Master".Code WHERE(Type = CONST(District));
        }
        field(150; "VR PO Box"; Text[20])
        {
        }
        field(151; "VR Country"; Text[20])
        {
            TableRelation = "Catalogues Master".Code WHERE(Type = CONST(Country));
        }
        field(152; "VR Telephone No.1"; Code[20])
        {

            trigger OnValidate()
            begin
                phoneNoValidation("VR Telephone No.1");
            end;
        }
        field(153; "VR Telephone No.2"; Code[20])
        {

            trigger OnValidate()
            begin
                phoneNoValidation("VR Telephone No.2");
            end;
        }
        field(154; "VR Mobile Number"; Code[20])
        {
        }
        field(155; "VR Fax1"; Text[20])
        {
        }
        field(156; "VR Fax2"; Text[20])
        {
        }
        field(157; "VR Email"; Text[30])
        {
        }
        field(159; "No Series"; Code[20])
        {
        }
        field(161; "Customer No."; Code[20])
        {
            TableRelation = Customer;
        }
        field(162; "Related Entity DOB"; Date)
        {
        }
        field(163; "Security Valuator Type"; Text[10])
        {
            TableRelation = "Catalogues Master" WHERE(Type = CONST(Security Valuator Type));
        }
        field(164; "Description Of Security"; Text[40])
        {
        }
        field(165; "Nature of Charge"; Code[10])
        {
            TableRelation = "Catalogues Master" WHERE(Type = CONST(Nature of Change));
        }
        field(166; "Security Coverage Percentage"; Decimal)
        {
            DecimalPlaces = 0 : 2;
        }
        field(167; "Latest Value of Security"; Integer)
        {
        }
        field(168; "Date of Latest Valuation"; Date)
        {
        }
        field(169; "VR Nature of Relationship"; Code[5])
        {
            TableRelation = "Catalogues Master" WHERE(Type = CONST(Nature of Relationship));

            trigger OnValidate()
            begin
                IF ("VR Nature of Relationship" = '001') OR ("VR Nature of Relationship" = '029') THEN
                    ERROR('Error Natuer of relation cant be 001 or 029');
            end;
        }
        field(171; "Nature of Relationship"; Text[5])
        {
            Description = 'KSKL 1.0';
            TableRelation = "Catalogues Master".Code WHERE(Type = CONST(Nature of Relationship));

            trigger OnValidate()
            begin
                IF ("Nature of Relationship" = '001') OR ("Nature of Relationship" = '029') THEN BEGIN
                END
                ELSE
                    ERROR('Error Nature of relation should be be 001 or 029');
            end;
        }
        field(172; "Valuator No."; Code[10])
        {
        }
        field(173; "VR Legal Status"; Code[5])
        {
            TableRelation = "Catalogues Master" WHERE(Type = CONST(Legal Status));

            trigger OnValidate()
            begin
                TESTFIELD("Valuator Reltn Entity Type");
                IF "Valuator Reltn Entity Type" <> '002' THEN
                    ERROR('Valuator Relation entity must be 002');
            end;
        }
        field(174; "BR Legal Status"; Code[5])
        {
            TableRelation = "Catalogues Master" WHERE(Type = CONST(Legal Status));

            trigger OnValidate()
            begin
                //TESTFIELD("Valuator Reltn Entity Type");  //19
                //IF "Valuator Reltn Entity Type" <> '002' THEN
                //ERROR('Valuator Relation entity must be 002');
            end;
        }
        field(175; "BR Nature of Relationship"; Code[5])
        {
            TableRelation = "Catalogues Master" WHERE(Type = CONST(Nature of Relationship));

            trigger OnValidate()
            begin
                IF ("BR Nature of Relationship" = '001') OR ("BR Nature of Relationship" = '029') THEN
                    ERROR('Error Natuer of relation cant be 001 or 029');
            end;
        }
        field(176; "RS Legal Status"; Code[5])
        {
            TableRelation = "Catalogues Master" WHERE(Type = CONST(Legal Status));

            trigger OnValidate()
            begin
                //TESTFIELD("Valuator Reltn Entity Type");
                /*IF "Valuator Reltn Entity Type" <> '002' THEN
                  ERROR('Valuator Relation entity must be 002');
                  */

            end;
        }
        field(177; "RE Passport Exp Date"; Date)
        {
        }
        field(178; "Percentage of Control"; Integer)
        {
            Description = 'KSKL 1.0';
        }
        field(179; "RS Gurantee Type"; Text[5])
        {
            Description = 'KSKL 1.0';
            TableRelation = "Catalogues Master".Code WHERE(Type = CONST(Guarantee Type));
        }
        field(180; "RS Father Name"; Text[50])
        {
        }
        field(181; "RS Nature of Relationship"; Code[5])
        {
            TableRelation = "Catalogues Master" WHERE(Type = CONST(Nature of Relationship));

            trigger OnValidate()
            var
                Cus: Record "18";
            begin
                TESTFIELD("Customer No.");
                Cus.GET("Customer No.");
                IF Cus."Nature of Data" = '001' THEN BEGIN
                    IF (Rec."RS Nature of Relationship" = '001') OR (Rec."RS Nature of Relationship" = '029') THEN BEGIN
                    END
                    ELSE
                        ERROR('Error Nature of relation should be be 001 or 029');
                END;
            end;
        }
        field(182; "RS Indian Embassy Reg No."; Code[10])
        {
        }
        field(183; "RS Indain Embassy Date"; Date)
        {
        }
        field(184; "RS Date of Leaving"; Date)
        {
        }
        field(185; "SS Type of Security"; Code[5])
        {
            TableRelation = "Catalogues Master" WHERE(Type = CONST(Type of Security));
        }
        field(186; "SS Security Ownership Type"; Code[5])
        {
            TableRelation = "Catalogues Master" WHERE(Type = CONST(Security Owernship Type));
        }
        field(187; "VS Legal Status"; Code[5])
        {
            TableRelation = "Catalogues Master" WHERE(Type = CONST(Legal Status));

            trigger OnValidate()
            begin
                TESTFIELD("Valuator Reltn Entity Type");
                IF "Valuator Reltn Entity Type" <> '002' THEN
                    ERROR('Valuator Relation entity must be 002');
            end;
        }
        field(189; "Has BR"; Boolean)
        {
        }
    }

    keys
    {
        key(Key1; "Related Entity No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        IF "Related Entity No." = '' THEN BEGIN
            KSKLSetup.GET;
            KSKLSetup.TESTFIELD(KSKLSetup."Customer RE Number");
            CLEAR(NoserMgmt);
            NoserMgmt.InitSeries(KSKLSetup."Customer RE Number", xRec."No Series", 0D, "Related Entity No.", Rec."No Series");
        END;
    end;

    var
        KSKLSetup: Record "33019801";
        NoserMgmt: Codeunit "396";

    local procedure phoneNoValidation(Ph: Text)
    begin
        IF Ph <> '' THEN BEGIN
            IF COPYSTR(Ph, 1, 4) <> '+977' THEN
                ERROR('Phone number should start from +977');
        END;
    end;
}

