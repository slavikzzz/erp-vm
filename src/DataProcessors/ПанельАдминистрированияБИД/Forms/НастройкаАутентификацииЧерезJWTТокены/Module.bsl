#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	КлючСопоставленияПользователей1СДокументооборот =
		Константы.КлючСопоставленияПользователей1СДокументооборот.Получить();
	КлючПодписиТокенаДоступа1СДокументооборот =
		Константы.КлючПодписиТокенаДоступа1СДокументооборот.Получить();
	
	Если Не ЗначениеЗаполнено(КлючСопоставленияПользователей1СДокументооборот) Тогда
		КлючСопоставленияПользователей1СДокументооборот =
			Перечисления.КлючиСопоставленияПользователей1СДокументооборот.ПользовательОС;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(КлючПодписиТокенаДоступа1СДокументооборот) Тогда
		СгенерироватьНовыйКлючАвтоматически = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	УстановитьДоступность();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СгенерироватьНовыйКлючАвтоматическиПриИзменении(Элемент)
	
	УстановитьДоступность();
	
КонецПроцедуры

&НаКлиенте
Процедура КлючСопоставленияПользователей1СДокументооборотПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(КлючПодписиТокенаДоступа1СДокументооборот)
			Или СгенерироватьНовыйКлючАвтоматически Тогда
		СгенерироватьОписаниеНаСервере();
	Иначе
		ОписаниеПубликации = "";
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КлючПодписиТокенаДоступа1СДокументооборотПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(КлючПодписиТокенаДоступа1СДокументооборот)
			Или СгенерироватьНовыйКлючАвтоматически Тогда
		СгенерироватьОписаниеНаСервере();
	Иначе
		ОписаниеПубликации = "";
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СгенерироватьОписание(Команда)
	
	Если Не ЗначениеЗаполнено(КлючПодписиТокенаДоступа1СДокументооборот)
			И Не СгенерироватьНовыйКлючАвтоматически Тогда
		ТекущийЭлемент = Элементы.КлючПодписиТокенаДоступа1СДокументооборот;
		ПоказатьПредупреждение(, НСтр("ru = 'Не указан ключ подписи JWT-токенов.';
										|en = 'A signature key of JWT tokens is not specified.'"));
		Возврат;
	КонецЕсли;
	
	СгенерироватьОписаниеНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ПрименитьВнесенныеНастройки(Команда)
	
	Если Не ЗначениеЗаполнено(КлючПодписиТокенаДоступа1СДокументооборот)
			И Не СгенерироватьНовыйКлючАвтоматически Тогда
		ТекущийЭлемент = Элементы.КлючПодписиТокенаДоступа1СДокументооборот;
		ПоказатьПредупреждение(, НСтр("ru = 'Не указан ключ подписи JWT-токенов.';
										|en = 'A signature key of JWT tokens is not specified.'"));
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ОписаниеПубликации) Тогда
		ТекущийЭлемент = Элементы.СгенерироватьОписание;
		ПоказатьПредупреждение(, НСтр("ru = 'Не сформировано описание веб-сервиса 1С:Документооборот.';
										|en = 'The details of 1C:Document Management web service are not generated.'"));
		Возврат;
	КонецЕсли;
	
	ПрименитьНастройкиНаСервере();
	
	Закрыть(Истина);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура СгенерироватьОписаниеНаСервере()
	
	Если СгенерироватьНовыйКлючАвтоматически Тогда
		Хеш = Новый ХешированиеДанных(ХешФункция.SHA256);
		Хеш.Добавить(Строка(Новый УникальныйИдентификатор));
		КлючПодписиТокенаДоступа1СДокументооборот = Base64Строка(Хеш.ХешСумма);
	КонецЕсли;
	
	ПолучателиТокенаДоступа = ИнтеграцияС1СДокументооборотБазоваяФункциональность.ПолучателиТокенаДоступа();
	ИмяВебСервисаДокументооборота = ИнтеграцияС1СДокументооборотБазоваяФункциональность.ИмяВебСервисаДокументооборота();
	ПсевдонимВебСервисаДокументооборота =
		ИнтеграцияС1СДокументооборотБазоваяФункциональность.ПсевдонимВебСервисаДокументооборота();
	ЭмитентТокенаДоступа = ИнтеграцияС1СДокументооборотБазоваяФункциональность.ЭмитентТокенаДоступа();
	
	Если КлючСопоставленияПользователей1СДокументооборот =
			Перечисления.КлючиСопоставленияПользователей1СДокументооборот.ИмяПользователяИБ Тогда
		ИмяКлючаСопоставленияПользователей = "name";
	ИначеЕсли КлючСопоставленияПользователей1СДокументооборот =
			Перечисления.КлючиСопоставленияПользователей1СДокументооборот.ПользовательОС Тогда
		ИмяКлючаСопоставленияПользователей = "OSUser";
	КонецЕсли;
	
	ШаблонОписанияПубликации =
		"<point name=""%1""
		|		alias=""%2""
		|		enable=""true""
		|		reuseSessions=""dontuse""
		|		sessionMaxAge=""20""
		|		poolSize=""10""
		|		poolTimeout=""5"">
		|		<accessTokenAuthentication>
		|		<accessTokenRecepientName>%3</accessTokenRecepientName>
		|			<issuers>
		|				<issuer
		|					name=""%4""
		|					authenticationClaimName=""sub""
		|					authenticationUserPropertyName=""%5""
		|					keyInformation=""%6""
		|				/>
		|			</issuers>
		|		</accessTokenAuthentication>
		|</point>";
	
	ОписаниеПубликации = СтрШаблон(ШаблонОписанияПубликации,
		ИмяВебСервисаДокументооборота,
		ПсевдонимВебСервисаДокументооборота,
		ПолучателиТокенаДоступа[0],
		ЭмитентТокенаДоступа,
		ИмяКлючаСопоставленияПользователей,
		КлючПодписиТокенаДоступа1СДокументооборот);
	
КонецПроцедуры

&НаСервере
Процедура ПрименитьНастройкиНаСервере()
	
	Константы.КлючСопоставленияПользователей1СДокументооборот.Установить(КлючСопоставленияПользователей1СДокументооборот);
	Константы.КлючПодписиТокенаДоступа1СДокументооборот.Установить(КлючПодписиТокенаДоступа1СДокументооборот);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьДоступность()
	
	Элементы.КлючПодписиТокенаДоступа1СДокументооборот.Доступность = Не СгенерироватьНовыйКлючАвтоматически;
	Элементы.КлючПодписиТокенаДоступа1СДокументооборот.АвтоОтметкаНезаполненного = Не СгенерироватьНовыйКлючАвтоматически;
	
КонецПроцедуры

#КонецОбласти
