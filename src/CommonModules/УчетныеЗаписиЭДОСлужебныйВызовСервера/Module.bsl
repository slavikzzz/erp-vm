
#Область СлужебныеПроцедурыИФункции

Процедура ЗаполнитьДанныеЗаявки(Знач ДополнительныеПараметры, ДанныеЗаявки) Экспорт
	
	СертификатКриптографии   = ДополнительныеПараметры.Сертификат;
	АдресОрганизацииЗначение = ДополнительныеПараметры.АдресОрганизацииЗначение;
		
	ПараметрыСертификата = КриптографияБЭД.СвойстваСертификатов(
		ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(СертификатКриптографии))[СертификатКриптографии];
	Ответ = ИнтеграцияБСПБЭД.СведенияОбАдресеПоЗначению(АдресОрганизацииЗначение);
	
	Если НЕ ЗначениеЗаполнено(Ответ.Город) Тогда
		Ответ.Город = Ответ.Регион;
	КонецЕсли;
	
	ТекущаяДатаСеанса = ТекущаяДатаСеанса();
	КонтактнаяИнформация = УправлениеКонтактнойИнформацией.КонтактнаяИнформацияОбъекта(
		ДополнительныеПараметры.Организация, Справочники.ВидыКонтактнойИнформации.ТелефонОрганизации,
		ТекущаяДатаСеанса, Ложь);
	Если КонтактнаяИнформация.Количество() Тогда
		СведенияОТелефоне = УправлениеКонтактнойИнформацией.СведенияОТелефоне(КонтактнаяИнформация[0].Значение);
		Если ЗначениеЗаполнено(СведенияОТелефоне.Добавочный) Тогда
			ТелефонБезДобавочного = УправлениеКонтактнойИнформациейКлиентСервер.СформироватьПредставлениеТелефона(
				СведенияОТелефоне.КодСтраны, СведенияОТелефоне.КодГорода, СведенияОТелефоне.НомерТелефона, "", "");
			ДанныеЗаявки.Телефон = ТелефонБезДобавочного;
		КонецЕсли;
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(ДанныеЗаявки, Ответ);
	ЗаполнитьЗначенияСвойств(ДанныеЗаявки, ПараметрыСертификата, "Фамилия, Имя, Отчество");
	
КонецПроцедуры

Функция НачатьУдалениеУчетнойЗаписи(ИдентификаторУчетнойЗаписи, ИдентификаторФормы) Экспорт
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияФункции(ИдентификаторФормы);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НСтр("ru = 'Удаление учетной записи электронного документооборота';
															|en = 'Delete EDI account'");
	
	Возврат ДлительныеОперации.ВыполнитьФункцию(ПараметрыВыполнения, "УчетныеЗаписиЭДОСлужебный.УдалитьУчетнуюЗапись",
		ИдентификаторУчетнойЗаписи);
	
КонецФункции

#КонецОбласти