
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	СтруктураДанных = Параметры.СтруктураДанных;
	
	ТолькоПросмотрФормы = СтруктураДанных.Свойство("ТолькоПросмотрФормы") И СтруктураДанных.ТолькоПросмотрФормы;
	Если ТолькоПросмотрФормы Тогда
		Элементы.Представитель.ТолькоПросмотр 						= Истина;
		Элементы.ПредставительЯвляетсяСотрудником.ТолькоПросмотр 	= Истина;
		Элементы.ПредставительЮЛ_НаимОрг.ТолькоПросмотр 			= Истина;
		Элементы.ПредставительЮЛ_ИНН.ТолькоПросмотр 				= Истина;
		Элементы.ПредставительЮЛ_КПП.ТолькоПросмотр 				= Истина;
		Элементы.ПредставительЮЛ_ОГРН.ТолькоПросмотр 				= Истина;
		Элементы.ПредставительФЛ_ФИО.ТолькоПросмотр 				= Истина;
		Элементы.ПредставительФЛ_Удостоверение.ТолькоПросмотр 		= Истина;
		Элементы.ПредставительФЛ_ИНН.ТолькоПросмотр 				= Истина;
		Элементы.ПредставительФЛ_НомЕРН.ТолькоПросмотр 				= Истина;
		Элементы.ПредставительФЛ_ОГРН.ТолькоПросмотр 				= Истина;
		Элементы.ПредставительФЛ_СНИЛС.ТолькоПросмотр 				= Истина;
		Элементы.ПредставительФЛ_Гражданство.ТолькоПросмотр 		= Истина;
		Элементы.ПредставительФЛ_ДатаРождения.ТолькоПросмотр 		= Истина;
		Элементы.ФормаКнопкаСохранить.Доступность 					= Ложь;
	КонецЕсли;
	
	МассивТипов = Новый Массив;
	МассивТипов.Добавить(Тип("СправочникСсылка.Контрагенты"));
	МассивТипов.Добавить(Тип("СправочникСсылка.Организации"));
	МассивТипов.Добавить(Тип("СправочникСсылка.ФизическиеЛица"));
	Элементы.Представитель.ОграничениеТипа = Новый ОписаниеТипов(МассивТипов);
	
	Если СтруктураДанных <> Неопределено Тогда
		ВерсияФормата 						= СтруктураДанных.ВерсияФормата;
		Доверитель 							= СтруктураДанных.Доверитель;
		Доверитель_ЮридическоеЛицо 			= СтруктураДанных.Доверитель_ЮридическоеЛицо;
		
		ДоверительЮЛ_НаимОрг 				= СтруктураДанных.ДоверительЮЛ_НаимОрг;
		ДоверительЮЛ_ИНН 					= СтруктураДанных.ДоверительЮЛ_ИНН;
		ДоверительЮЛ_КПП 					= СтруктураДанных.ДоверительЮЛ_КПП;
		ДоверительЮЛ_ОГРН 					= СтруктураДанных.ДоверительЮЛ_ОГРН;
		
		Представитель 						= СтруктураДанных.Представитель;
		Представитель_ЮридическоеЛицо 		= СтруктураДанных.Представитель_ЮридическоеЛицо;
		
		ПредставительЮЛ_НаимОрг 			= СтруктураДанных.ПредставительЮЛ_НаимОрг;
		ПредставительЮЛ_ИНН 				= СтруктураДанных.ПредставительЮЛ_ИНН;
		ПредставительЮЛ_КПП 				= СтруктураДанных.ПредставительЮЛ_КПП;
		ПредставительЮЛ_ОГРН 				= СтруктураДанных.ПредставительЮЛ_ОГРН;
		
		ПредставительФЛ_Фамилия 			= СтруктураДанных.ПредставительФЛ_Фамилия;
		ПредставительФЛ_Имя 				= СтруктураДанных.ПредставительФЛ_Имя;
		ПредставительФЛ_Отчество 			= СтруктураДанных.ПредставительФЛ_Отчество;
		ПредставительФЛ_ФИО 				= СтруктураДанных.ПредставительФЛ_ФИО;
		
		ПредставительФЛ_ВидДок 				= СтруктураДанных.ПредставительФЛ_ВидДок;
		ПредставительФЛ_СерДок 				= СтруктураДанных.ПредставительФЛ_СерДок;
		ПредставительФЛ_НомДок 				= СтруктураДанных.ПредставительФЛ_НомДок;
		ПредставительФЛ_ДатаДок 			= СтруктураДанных.ПредставительФЛ_ДатаДок;
		ПредставительФЛ_ВыдДок 				= СтруктураДанных.ПредставительФЛ_ВыдДок;
		ПредставительФЛ_КодВыдДок 			= СтруктураДанных.ПредставительФЛ_КодВыдДок;
		ПредставительФЛ_Удостоверение 		= СтруктураДанных.ПредставительФЛ_Удостоверение;
		
		ПредставительФЛ_ИНН 				= СтруктураДанных.ПредставительФЛ_ИНН;
		ПредставительФЛ_НомЕРН 				= СтруктураДанных.ПредставительФЛ_НомЕРН;
		ПредставительФЛ_ОГРН 				= СтруктураДанных.ПредставительФЛ_ОГРН;
		ПредставительФЛ_СНИЛС 				= СтруктураДанных.ПредставительФЛ_СНИЛС;
		ПредставительФЛ_Гражданство 		= СтруктураДанных.ПредставительФЛ_Гражданство;
		ПредставительФЛ_ДатаРождения 		= СтруктураДанных.ПредставительФЛ_ДатаРождения;
		
		ПредставительЯвляетсяСотрудником 	= СтруктураДанных.ПредставительЯвляетсяСотрудником;
	КонецЕсли;
	
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПредставительПриИзменении(Элемент)
	
	Если ТипЗнч(Представитель) = Тип("СправочникСсылка.Организации")
		И Представитель <> ПредопределенноеЗначение("Справочник.Организации.ПустаяСсылка") Тогда
		
		СвойстваОрганизации = ДокументооборотСКОВызовСервера.ПолучитьСвойстваОрганизации(Представитель);
		
		Представитель_ЮридическоеЛицо = СвойстваОрганизации.ЭтоЮридическоеЛицо;
		Если Доверитель_ЮридическоеЛицо И НЕ Представитель_ЮридическоеЛицо И ПредставительЯвляетсяСотрудником Тогда
			ПредставительЮЛ_НаимОрг = ДоверительЮЛ_НаимОрг;
			ПредставительЮЛ_ИНН 	= ДоверительЮЛ_ИНН;
			ПредставительЮЛ_КПП 	= ДоверительЮЛ_КПП;
			ПредставительЮЛ_ОГРН 	= ДоверительЮЛ_ОГРН;
		Иначе
			ПредставительЮЛ_НаимОрг = ?(СвойстваОрганизации.ЭтоЮридическоеЛицо,
				?(НЕ СвойстваОрганизации.ЭтоРоссийскаяОрганизация И ЗначениеЗаполнено(СвойстваОрганизации.НаимИОПол),
				СвойстваОрганизации.НаимИОПол, СвойстваОрганизации.НаимЮЛПол), "");
			ПредставительЮЛ_ИНН = ?(СвойстваОрганизации.ЭтоЮридическоеЛицо, СвойстваОрганизации.ИННЮЛ, "");
			ПредставительЮЛ_КПП = ?(СвойстваОрганизации.ЭтоЮридическоеЛицо, СвойстваОрганизации.КППЮЛ, "");
			ПредставительЮЛ_ОГРН = ?(СвойстваОрганизации.ЭтоЮридическоеЛицо, СвойстваОрганизации.ОГРН, "");
		КонецЕсли;
		
		ФизическоеЛицоПредставителяЗаполнено = ЗначениеЗаполнено(ПредставительФЛ_Фамилия)
			ИЛИ ЗначениеЗаполнено(ПредставительФЛ_Имя) ИЛИ ЗначениеЗаполнено(ПредставительФЛ_Отчество)
			ИЛИ ЗначениеЗаполнено(ПредставительФЛ_ВидДок) ИЛИ ЗначениеЗаполнено(ПредставительФЛ_СерДок)
			ИЛИ ЗначениеЗаполнено(ПредставительФЛ_НомДок) ИЛИ ЗначениеЗаполнено(ПредставительФЛ_ДатаДок)
			ИЛИ ЗначениеЗаполнено(ПредставительФЛ_ВыдДок) ИЛИ ЗначениеЗаполнено(ПредставительФЛ_КодВыдДок)
			ИЛИ ЗначениеЗаполнено(ПредставительФЛ_ИНН) ИЛИ ЗначениеЗаполнено(ПредставительФЛ_НомЕРН)
			ИЛИ ЗначениеЗаполнено(ПредставительФЛ_ОГРН) ИЛИ ЗначениеЗаполнено(ПредставительФЛ_СНИЛС)
			ИЛИ ЗначениеЗаполнено(ПредставительФЛ_Гражданство) ИЛИ ЗначениеЗаполнено(ПредставительФЛ_ДатаРождения);
		Если ФизическоеЛицоПредставителяЗаполнено Тогда
			ПредставительФЛ_Фамилия = ?(СвойстваОрганизации.ЭтоЮридическоеЛицо,
				СвойстваОрганизации.ФамилияРук, СвойстваОрганизации.ФамилияИП);
			ПредставительФЛ_Имя = ?(СвойстваОрганизации.ЭтоЮридическоеЛицо,
				СвойстваОрганизации.ИмяРук, СвойстваОрганизации.ИмяИП);
			ПредставительФЛ_Отчество = ?(СвойстваОрганизации.ЭтоЮридическоеЛицо,
				СвойстваОрганизации.ОтчествоРук, СвойстваОрганизации.ОтчествоИП);
			
			ПредставительФЛ_ФИО = ДокументооборотСКОКлиентСервер.ПолучитьПредставлениеФИО(ЭтаФорма, "ПредставительФЛ_");
			
			ПредставительФЛ_ВидДок = СвойстваОрганизации.ВидУдостоверения;
			ПредставительФЛ_СерДок = ?(СвойстваОрганизации.ЭтоЮридическоеЛицо,
				СвойстваОрганизации.СерияУдЛичнРук, СвойстваОрганизации.СерияУдЛичн);
			ПредставительФЛ_НомДок = ?(СвойстваОрганизации.ЭтоЮридическоеЛицо,
				СвойстваОрганизации.НомерУдЛичнРук, СвойстваОрганизации.НомерУдЛичн);
			ПредставительФЛ_ДатаДок = ?(СвойстваОрганизации.ЭтоЮридическоеЛицо,
				СвойстваОрганизации.ДатаУдЛичнРук, СвойстваОрганизации.ДатаУдЛичн);
			ПредставительФЛ_ВыдДок = ?(СвойстваОрганизации.ЭтоЮридическоеЛицо,
				СвойстваОрганизации.ОрганВыданУдЛичнРук, СвойстваОрганизации.ОрганВыданУдЛичн);
			ПредставительФЛ_КодВыдДок = ?(СвойстваОрганизации.ЭтоЮридическоеЛицо,
				СвойстваОрганизации.КодПодрУдЛичнРук, СвойстваОрганизации.КодПодрУдЛичн);
			
			ПредставительФЛ_Удостоверение =
				ДокументооборотСКОКлиентСервер.ПолучитьПредставлениеУдостоверение(ЭтаФорма, "ПредставительФЛ_");
			
			ПредставительФЛ_ИНН = ?(СвойстваОрганизации.ЭтоЮридическоеЛицо, СвойстваОрганизации.ИННРук,
				СвойстваОрганизации.ИННФЛ);
			ПредставительФЛ_НомЕРН = "";
			ПредставительФЛ_ОГРН = ?(СвойстваОрганизации.ЭтоЮридическоеЛицо, "", СвойстваОрганизации.ОГРН);
			ПредставительФЛ_СНИЛС = СвойстваОрганизации.СНИЛС;
			ПредставительФЛ_Гражданство = СвойстваОрганизации.Гражданство;
			ПредставительФЛ_ДатаРождения = ?(СвойстваОрганизации.ЭтоЮридическоеЛицо,
				СвойстваОрганизации.ДатаРождРук, СвойстваОрганизации.ДатаРожд);
		КонецЕсли;
		
		УправлениеФормой(ЭтаФорма);
		
	ИначеЕсли ТипЗнч(Представитель) = Тип("СправочникСсылка.Контрагенты")
		И Представитель <> ПредопределенноеЗначение("Справочник.Контрагенты.ПустаяСсылка") Тогда
		
		СвойстваКонтрагента = ДокументооборотСКОВызовСервера.ПолучитьСвойстваКонтрагента(Представитель);
		
		Если СвойстваКонтрагента.ЭтоЮридическоеЛицо = Истина Тогда
			Представитель_ЮридическоеЛицо = Истина;
			ПредставительЮЛ_НаимОрг = СвойстваКонтрагента.НаименованиеПолное;
			ПредставительЮЛ_ИНН = СвойстваКонтрагента.ИНН;
			ПредставительЮЛ_КПП = СвойстваКонтрагента.КПП;
			ПредставительЮЛ_ОГРН = "";
			
		ИначеЕсли СвойстваКонтрагента.ЭтоЮридическоеЛицо = Ложь Тогда
			Представитель_ЮридическоеЛицо = Ложь;
			Если Доверитель_ЮридическоеЛицо И ПредставительЯвляетсяСотрудником Тогда
				ПредставительЮЛ_НаимОрг 	= ДоверительЮЛ_НаимОрг;
				ПредставительЮЛ_ИНН 		= ДоверительЮЛ_ИНН;
				ПредставительЮЛ_КПП 		= ДоверительЮЛ_КПП;
				ПредставительЮЛ_ОГРН 		= ДоверительЮЛ_ОГРН;
			Иначе
				ПредставительЮЛ_НаимОрг = "";
				ПредставительЮЛ_ИНН 	= "";
				ПредставительЮЛ_КПП 	= "";
				ПредставительЮЛ_ОГРН 	= "";
			КонецЕсли;
			
			ПредставительЮЛ_Фамилия 	= СвойстваКонтрагента.Фамилия;
			ПредставительЮЛ_Имя 		= СвойстваКонтрагента.Имя;
			ПредставительЮЛ_Отчество 	= СвойстваКонтрагента.Отчество;
			
			ПредставительФЛ_ФИО = ДокументооборотСКОКлиентСервер.ПолучитьПредставлениеФИО(ЭтаФорма, "ПредставительФЛ_");
			
			ПредставительФЛ_Удостоверение = "";
			
			ПредставительФЛ_ИНН 			= СвойстваКонтрагента.ИНН;
			ПредставительФЛ_НомЕРН 			= "";
			ПредставительФЛ_ОГРН 			= "";
			ПредставительФЛ_СНИЛС 			= "";
			ПредставительФЛ_Гражданство 	= ПредопределенноеЗначение("Справочник.СтраныМира.ПустаяСсылка");
			ПредставительФЛ_ДатаРождения 	= Неопределено;
		КонецЕсли;
		
		УправлениеФормой(ЭтаФорма);
		
	ИначеЕсли ТипЗнч(Представитель) = Тип("СправочникСсылка.ФизическиеЛица")
		И Представитель <> ПредопределенноеЗначение("Справочник.ФизическиеЛица.ПустаяСсылка") Тогда
		
		СвойстваФизическогоЛица = ДокументооборотСКОВызовСервера.ПолучитьСвойстваФизическогоЛица(Представитель);
		
		Представитель_ЮридическоеЛицо 	= Ложь;
		Если Доверитель_ЮридическоеЛицо И ПредставительЯвляетсяСотрудником Тогда
			ПредставительЮЛ_НаимОрг = ДоверительЮЛ_НаимОрг;
			ПредставительЮЛ_ИНН 	= ДоверительЮЛ_ИНН;
			ПредставительЮЛ_КПП 	= ДоверительЮЛ_КПП;
			ПредставительЮЛ_ОГРН 	= ДоверительЮЛ_ОГРН;
		Иначе
			ПредставительЮЛ_НаимОрг = "";
			ПредставительЮЛ_ИНН 	= "";
			ПредставительЮЛ_КПП 	= "";
			ПредставительЮЛ_ОГРН 	= "";
		КонецЕсли;
		
		ПредставительФЛ_Фамилия 	= СвойстваФизическогоЛица.ФИО.Фамилия;
		ПредставительФЛ_Имя 		= СвойстваФизическогоЛица.ФИО.Имя;
		ПредставительФЛ_Отчество 	= СвойстваФизическогоЛица.ФИО.Отчество;
		
		ПредставительФЛ_ФИО = ДокументооборотСКОКлиентСервер.ПолучитьПредставлениеФИО(ЭтаФорма, "ПредставительФЛ_");
		
		ПредставительФЛ_ВидДок 		= СвойстваФизическогоЛица.ВидДокумента;
		ПредставительФЛ_СерДок 		= СвойстваФизическогоЛица.Серия;
		ПредставительФЛ_НомДок 		= СвойстваФизическогоЛица.Номер;
		ПредставительФЛ_ДатаДок 	= СвойстваФизическогоЛица.ДатаВыдачи;
		ПредставительФЛ_ВыдДок 		= СвойстваФизическогоЛица.КемВыдан;
		ПредставительФЛ_КодВыдДок 	= СвойстваФизическогоЛица.КодПодразделения;
		
		ПредставительФЛ_Удостоверение =
			ДокументооборотСКОКлиентСервер.ПолучитьПредставлениеУдостоверение(ЭтаФорма, "ПредставительФЛ_");
		
		ПредставительФЛ_ИНН 			= СвойстваФизическогоЛица.ИНН;
		ПредставительФЛ_НомЕРН 			= "";
		ПредставительФЛ_ОГРН 			= "";
		ПредставительФЛ_СНИЛС 			= СвойстваФизическогоЛица.СНИЛС;
		ПредставительФЛ_Гражданство 	= СвойстваФизическогоЛица.Гражданство;
		ПредставительФЛ_ДатаРождения 	= СвойстваФизическогоЛица.ДатаРождения;
		
		УправлениеФормой(ЭтаФорма);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПредставительОчистка(Элемент, СтандартнаяОбработка)
	
	ПредставительЮЛ_НаимОрг = "";
	ПредставительЮЛ_ИНН = "";
	ПредставительЮЛ_КПП = "";
	ПредставительЮЛ_ОГРН = "";
	
	ПредставительФЛ_Фамилия = "";
	ПредставительФЛ_Имя = "";
	ПредставительФЛ_Отчество = "";
	ПредставительФЛ_ФИО = "";
	
	ПредставительФЛ_ИНН = "";
	ПредставительФЛ_НомЕРН = "";
	ПредставительФЛ_ОГРН = "";
	ПредставительФЛ_СНИЛС = "";
	ПредставительФЛ_Гражданство = ПредопределенноеЗначение("Справочник.СтраныМира.ПустаяСсылка");
	ПредставительФЛ_ДатаРождения = Неопределено;
	
	ПредставительФЛ_ВидДок = ПредопределенноеЗначение("Справочник.ВидыДокументовФизическихЛиц.ПустаяСсылка");
	ПредставительФЛ_СерДок = "";
	ПредставительФЛ_НомДок = "";
	ПредставительФЛ_ДатаДок = Неопределено;
	ПредставительФЛ_ВыдДок = "";
	ПредставительФЛ_КодВыдДок = "";
	ПредставительФЛ_Удостоверение = "";
	
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПредставительЯвляетсяСотрудникомПриИзменении(Элемент)
	
	Если Доверитель_ЮридическоеЛицо И НЕ Представитель_ЮридическоеЛицо И ПредставительЯвляетсяСотрудником Тогда
		ПредставительЮЛ_НаимОрг = ДоверительЮЛ_НаимОрг;
		ПредставительЮЛ_ИНН 	= ДоверительЮЛ_ИНН;
		ПредставительЮЛ_КПП 	= ДоверительЮЛ_КПП;
		ПредставительЮЛ_ОГРН 	= ДоверительЮЛ_ОГРН;
		
	Иначе
		ПредставительЮЛ_НаимОрг = "";
		ПредставительЮЛ_ИНН 	= "";
		ПредставительЮЛ_КПП 	= "";
		ПредставительЮЛ_ОГРН 	= "";
	КонецЕсли;
	
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПредставительФЛ_ФИОНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ФормаВводаФИО = РегламентированнаяОтчетностьКлиент.ПолучитьОбщуюФормуПоИмени("ФормаВводаФИО");
	
	ФормаВводаФИО.Фамилия 	= ПредставительФЛ_Фамилия;
	ФормаВводаФИО.Имя 		= ПредставительФЛ_Имя;
	ФормаВводаФИО.Отчество 	= ПредставительФЛ_Отчество;
	
	ФормаВводаФИО.ОписаниеОповещенияОЗакрытии =
		Новый ОписаниеОповещения("ПредставительФЛ_ФИОНачалоВыбораПослеВвода", ЭтотОбъект);
	ФормаВводаФИО.РежимОткрытияОкна = РежимОткрытияОкнаФормы.БлокироватьОкноВладельца;
	ФормаВводаФИО.Открыть();
	
КонецПроцедуры

&НаКлиенте
Процедура ПредставительФЛ_ФИООчистка(Элемент, СтандартнаяОбработка)
	
	ПредставительФЛ_Фамилия 	= "";
	ПредставительФЛ_Имя 		= "";
	ПредставительФЛ_Отчество 	= "";
	
	ПредставительФЛ_ФИО = "";
	
КонецПроцедуры

&НаКлиенте
Процедура ПредставительФЛ_УдостоверениеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтруктураДанных = Новый Структура;
	СтруктураДанных.Вставить("ДокументВид", 				ПредставительФЛ_ВидДок);
	СтруктураДанных.Вставить("ДокументСерия", 				ПредставительФЛ_СерДок);
	СтруктураДанных.Вставить("ДокументНомер", 				ПредставительФЛ_НомДок);
	СтруктураДанных.Вставить("ДокументДатаВыдачи", 			ПредставительФЛ_ДатаДок);
	СтруктураДанных.Вставить("ДокументКемВыдан", 			ПредставительФЛ_ВыдДок);
	СтруктураДанных.Вставить("ДокументКодПодразделения", 	ПредставительФЛ_КодВыдДок);
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПредставительФЛ_УдостоверениеНачалоВыбораПослеВвода", ЭтотОбъект);
	ОткрытьФорму(
		"Справочник.МашиночитаемыеДоверенностиФНС.Форма.ФормаВводаУдостоверения",
		Новый Структура("СтруктураДанных", СтруктураДанных),
		ЭтаФорма,,,,
		ОписаниеОповещения,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ПредставительФЛ_УдостоверениеОчистка(Элемент, СтандартнаяОбработка)
	
	ПредставительФЛ_ВидДок 	= ПредопределенноеЗначение("Справочник.ВидыДокументовФизическихЛиц.ПустаяСсылка");
	ПредставительФЛ_СерДок 	= "";
	ПредставительФЛ_НомДок 	= "";
	ПредставительФЛ_ДатаДок 	= Неопределено;
	ПредставительФЛ_ВыдДок 	= "";
	ПредставительФЛ_КодВыдДок 	= "";
	
	ПредставительФЛ_Удостоверение = "";
	
	Модифицированность = Истина;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)
	
	ЭтоВерсия5_03 = ЗначениеЗаполнено(Форма.ВерсияФормата)
		И ОбщегоНазначенияКлиентСервер.СравнитьВерсии(Форма.ВерсияФормата + ".0.0", "5.03.0.0") >= 0;
	
	Форма.Элементы.ГруппаПредставительЮЛ_НаимОрг.Видимость = Форма.Представитель_ЮридическоеЛицо;
	Форма.Элементы.ГруппаПредставительЮЛ_ИННКПП.Видимость = Форма.Представитель_ЮридическоеЛицо;
	Форма.Элементы.ГруппаПредставительЮЛ_ОГРН.Видимость = Форма.Представитель_ЮридическоеЛицо;
	
	Форма.Элементы.ГруппаПредставительФЛ_ФИО.ОтображатьЗаголовок = Форма.Представитель_ЮридическоеЛицо;
	
	Форма.Элементы.ДекорацияПредставительФЛ_ИНННомЕРНРазделитель.Видимость = ЭтоВерсия5_03;
	Форма.Элементы.ДекорацияПредставительФЛ_НомЕРН.Видимость = ЭтоВерсия5_03;
	Форма.Элементы.ПредставительФЛ_НомЕРН.Видимость = ЭтоВерсия5_03;
	Форма.Элементы.ПредставительЯвляетсяСотрудником.Видимость = НЕ Форма.Представитель_ЮридическоеЛицо;
	
КонецПроцедуры

&НаКлиенте
Процедура Сохранить(Команда)
	
	Если НЕ СохранениеВозможно() Тогда
		Возврат;
	КонецЕсли;
	
	СтруктураДанных = Новый Структура;
	СтруктураДанных.Вставить("Представитель", 						Представитель);
	
	СтруктураДанных.Вставить("ПредставительЮЛ_НаимОрг", 			?(Представитель_ЮридическоеЛицо
																	ИЛИ ПредставительЯвляетсяСотрудником, ПредставительЮЛ_НаимОрг, ""));
	СтруктураДанных.Вставить("ПредставительЮЛ_ИНН", 				?(Представитель_ЮридическоеЛицо
																	ИЛИ ПредставительЯвляетсяСотрудником, ПредставительЮЛ_ИНН, ""));
	СтруктураДанных.Вставить("ПредставительЮЛ_КПП", 				?(Представитель_ЮридическоеЛицо
																	ИЛИ ПредставительЯвляетсяСотрудником, ПредставительЮЛ_КПП, ""));
	СтруктураДанных.Вставить("ПредставительЮЛ_ОГРН", 				?(Представитель_ЮридическоеЛицо
																	ИЛИ ПредставительЯвляетсяСотрудником, ПредставительЮЛ_ОГРН, ""));
	
	СтруктураДанных.Вставить("ПредставительФЛ_Фамилия", 			ПредставительФЛ_Фамилия);
	СтруктураДанных.Вставить("ПредставительФЛ_Имя", 				ПредставительФЛ_Имя);
	СтруктураДанных.Вставить("ПредставительФЛ_Отчество", 			ПредставительФЛ_Отчество);
	
	СтруктураДанных.Вставить("ПредставительФЛ_ВидДок", 				ПредставительФЛ_ВидДок);
	СтруктураДанных.Вставить("ПредставительФЛ_СерДок", 				ПредставительФЛ_СерДок);
	СтруктураДанных.Вставить("ПредставительФЛ_НомДок", 				ПредставительФЛ_НомДок);
	СтруктураДанных.Вставить("ПредставительФЛ_ДатаДок", 			ПредставительФЛ_ДатаДок);
	СтруктураДанных.Вставить("ПредставительФЛ_ВыдДок", 				ПредставительФЛ_ВыдДок);
	СтруктураДанных.Вставить("ПредставительФЛ_КодВыдДок", 			ПредставительФЛ_КодВыдДок);
	
	СтруктураДанных.Вставить("ПредставительФЛ_ИНН", 				ПредставительФЛ_ИНН);
	СтруктураДанных.Вставить("ПредставительФЛ_НомЕРН", 				ПредставительФЛ_НомЕРН);
	СтруктураДанных.Вставить("ПредставительФЛ_ОГРН", 				ПредставительФЛ_ОГРН);
	СтруктураДанных.Вставить("ПредставительФЛ_СНИЛС", 				ПредставительФЛ_СНИЛС);
	СтруктураДанных.Вставить("ПредставительФЛ_Гражданство", 		ПредставительФЛ_Гражданство);
	СтруктураДанных.Вставить("ПредставительФЛ_ДатаРождения", 		ПредставительФЛ_ДатаРождения);
	
	СтруктураДанных.Вставить("ПредставительЯвляетсяСотрудником", 	ПредставительЯвляетсяСотрудником
																	И НЕ Представитель_ЮридическоеЛицо);
	
	Закрыть(СтруктураДанных);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Функция СохранениеВозможно()
	
	Отказ = Ложь;
	
	ОчиститьСообщения();
	
	ЭтоВерсия5_03 = ЗначениеЗаполнено(ВерсияФормата)
		И ОбщегоНазначенияКлиентСервер.СравнитьВерсии(ВерсияФормата + ".0.0", "5.03.0.0") >= 0;
	
	Если Представитель_ЮридическоеЛицо Тогда
		Если НЕ ЗначениеЗаполнено(ПредставительЮЛ_НаимОрг) Тогда
			ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Не задано наименование организации представителя.';
															|en = 'Не задано наименование организации представителя.'"),,
				"Представитель",, Отказ);
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(ПредставительЮЛ_ИНН) Тогда
			ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Не задан ИНН организации представителя.';
															|en = 'Не задан ИНН организации представителя.'"),,
				"Представитель",, Отказ);
		ИначеЕсли НЕ РегламентированнаяОтчетностьВызовСервера.ИННСоответствуетТребованиямНаСервере(
			ПредставительЮЛ_ИНН, Ложь) Тогда
			ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Указан некорректный ИНН организации представителя.';
															|en = 'Указан некорректный ИНН организации представителя.'"),,
				"Представитель",, Отказ);
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(ПредставительЮЛ_КПП) Тогда
			ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Не задан КПП организации представителя.';
															|en = 'Не задан КПП организации представителя.'"),,
				"Представитель",, Отказ);
		ИначеЕсли СтрДлина(СокрЛП(ПредставительЮЛ_КПП)) <> 9 Тогда
			ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Указан некорректный КПП организации представителя.';
															|en = 'Указан некорректный КПП организации представителя.'"),,
				"Представитель",, Отказ);
		КонецЕсли;
		
		Если ЗначениеЗаполнено(ПредставительЮЛ_ОГРН) И СтрДлина(СокрЛП(ПредставительЮЛ_ОГРН)) <> 13 Тогда
			ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Указан некорректный ОГРН организации представителя.';
															|en = 'Указан некорректный ОГРН организации представителя.'"),,
				"Представитель",, Отказ);
		КонецЕсли;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(ПредставительФЛ_Фамилия) Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Не задана фамилия.';
														|en = 'Не задана фамилия.'"),,
			"ПредставительФЛ_ФИО",, Отказ);
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(ПредставительФЛ_Имя) Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Не задано имя.';
														|en = 'Не задано имя.'"),,
			"ПредставительФЛ_ФИО",, Отказ);
	КонецЕсли;
	
	КодВидаДокумента = ДокументооборотСКОВызовСервера.ПолучитьКодВидаДокументаФизическогоЛица(ПредставительФЛ_ВидДок);
	Если ЗначениеЗаполнено(КодВидаДокумента) И КодВидаДокумента <> "07" И КодВидаДокумента <> "10"
		И КодВидаДокумента <> "11" И КодВидаДокумента <> "12" И КодВидаДокумента <> "13" И КодВидаДокумента <> "15"
		И КодВидаДокумента <> "19" И КодВидаДокумента <> "21" И КодВидаДокумента <> "24" Тогда
		
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Вид документа не поддерживается.';
														|en = 'Вид документа не поддерживается.'"),,
			"ПредставительФЛ_Удостоверение",, Отказ);
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(СокрЛП(ПредставительФЛ_СерДок) + СокрЛП(ПредставительФЛ_НомДок)) Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Не заданы серия и номер документа.';
														|en = 'Не заданы серия и номер документа.'"),,
			"ПредставительФЛ_Удостоверение",, Отказ);
	КонецЕсли;
	
	Если СтрДлина(СокрЛП(ПредставительФЛ_СерДок) + СокрЛП(ПредставительФЛ_НомДок)) > 25 Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Длина серии и номера документа больше 25 символов.';
														|en = 'Длина серии и номера документа больше 25 символов.'"),,
			"ЛицоБезДовФЛ_Удостоверение",, Отказ);
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(ПредставительФЛ_ДатаДок) Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Не задана дата выдачи документа.';
														|en = 'Не задана дата выдачи документа.'"),,
			"ПредставительФЛ_Удостоверение",, Отказ);
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(ПредставительФЛ_ВыдДок) И КодВидаДокумента = "21" Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Не задано наименование органа, выдавшего документ.';
														|en = 'Не задано наименование органа, выдавшего документ.'"),,
			"ПредставительФЛ_Удостоверение",, Отказ);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ПредставительФЛ_ИНН)
		И НЕ РегламентированнаяОтчетностьВызовСервера.ИННСоответствуетТребованиямНаСервере(ПредставительФЛ_ИНН, Истина) Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Указан некорректный ИНН.';
														|en = 'Указан некорректный ИНН.'"),,
			"ПредставительФЛ_ИНН",, Отказ);
	КонецЕсли;
	
	Если ЭтоВерсия5_03 И ЗначениеЗаполнено(ПредставительФЛ_НомЕРН) И СтрДлина(СокрЛП(ПредставительФЛ_НомЕРН)) <> 15 Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Указан некорректный номер ЕРН.';
														|en = 'Указан некорректный номер ЕРН.'"),,
			"ПредставительФЛ_НомЕРН",, Отказ);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ПредставительФЛ_ОГРН) И СтрДлина(СокрЛП(ПредставительФЛ_ОГРН)) <> 15 Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Указан некорректный ОГРНИП.';
														|en = 'Указан некорректный ОГРНИП.'"),,
			"ПредставительФЛ_ОГРН",, Отказ);
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(ПредставительФЛ_СНИЛС) Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Не задан СНИЛС.';
														|en = 'Не задан СНИЛС.'"),,
			"ПредставительФЛ_СНИЛС",, Отказ);
	ИначеЕсли СтрДлина(СокрЛП(ПредставительФЛ_СНИЛС)) <> 14 Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Указан некорректный СНИЛС.';
														|en = 'Указан некорректный СНИЛС.'"),,
			"ПредставительФЛ_СНИЛС",, Отказ);
	КонецЕсли;
	
	Возврат НЕ Отказ;
	
КонецФункции

&НаКлиенте
Процедура ПредставительФЛ_ФИОНачалоВыбораПослеВвода(РезультатРедактирования, ДополнительныеПараметры) Экспорт
	
	Если НЕ ЗначениеЗаполнено(РезультатРедактирования) Тогда
		Возврат;
	КонецЕсли;
	
	ПредставительФЛ_Фамилия 	= РезультатРедактирования.Фамилия;
	ПредставительФЛ_Имя 		= РезультатРедактирования.Имя;
	ПредставительФЛ_Отчество 	= РезультатРедактирования.Отчество;
	
	ПредставительФЛ_ФИО = ДокументооборотСКОКлиентСервер.ПолучитьПредставлениеФИО(РезультатРедактирования);
	
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ПредставительФЛ_УдостоверениеНачалоВыбораПослеВвода(РезультатВыбора, ДополнительныеПараметры) Экспорт
	
	Если НЕ ЗначениеЗаполнено(РезультатВыбора) Тогда
		Возврат;
	КонецЕсли;
	
	ПредставительФЛ_ВидДок 		= РезультатВыбора.ДокументВид;
	ПредставительФЛ_СерДок 		= РезультатВыбора.ДокументСерия;
	ПредставительФЛ_НомДок 		= РезультатВыбора.ДокументНомер;
	ПредставительФЛ_ДатаДок 	= РезультатВыбора.ДокументДатаВыдачи;
	ПредставительФЛ_ВыдДок 		= РезультатВыбора.ДокументКемВыдан;
	ПредставительФЛ_КодВыдДок 	= РезультатВыбора.ДокументКодПодразделения;
	
	ПредставительФЛ_Удостоверение = ДокументооборотСКОКлиентСервер.ПолучитьПредставлениеУдостоверение(РезультатВыбора);
	
	Модифицированность = Истина;
	
КонецПроцедуры

#КонецОбласти
