#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	Если ДанныеЗаполнения <> Неопределено
		И Метаданные.ОпределяемыеТипы.ОснованиеУвольнения.Тип.СодержитТип(ТипЗнч(ДанныеЗаполнения)) Тогда
		
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("Ссылка", ДанныеЗаполнения);
		Запрос.Текст =
			"ВЫБРАТЬ
			|	ОснованияУвольнения.Наименование КАК Наименование,
			|	ОснованияУвольнения.ТекстОснования КАК ТекстОснования,
			|	ОснованияУвольнения.Статья КАК Статья,
			|	ОснованияУвольнения.Часть КАК Часть,
			|	ОснованияУвольнения.Пункт КАК Пункт,
			|	ОснованияУвольнения.Подпункт КАК Подпункт,
			|	ОснованияУвольнения.Абзац КАК Абзац,
			|	ОснованияУвольнения.ДокументОснование КАК ДокументОснование
			|ИЗ
			|	Справочник.ОснованияУвольнения КАК ОснованияУвольнения
			|ГДЕ
			|	ОснованияУвольнения.Ссылка = &Ссылка";
		
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "Справочник.ОснованияУвольнения",
			ДанныеЗаполнения.Метаданные().ПолноеИмя());
		
		Выборка = Запрос.Выполнить().Выбрать();
		Если Выборка.Следующий() Тогда
			ЗаполнитьЗначенияСвойств(ЭтотОбъект, Выборка);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если Не ЗначениеЗаполнено(ДокументОснование) Тогда
		
		Если Не ЗначениеЗаполнено(НаименованиеДокументаОснования)
			И ЗначениеЗаполнено(НаименованиеДокументаОснованияВРодительномПадеже)Тогда
			
			ТекстСообщения = НСтр("ru = 'Поле ""Наименование документа основания"" не заполнено';
									|en = 'The ""Base document description"" field cannot be blank'");
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, Ссылка,
				"НаименованиеДокументаОснования", "Объект", Отказ);
			
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(НаименованиеДокументаОснованияВРодительномПадеже)
			И ЗначениеЗаполнено(НаименованиеДокументаОснования) Тогда
			
			ТекстСообщения = НСтр("ru = 'Поле ""Наименование документа основания (в родительном падеже)"" не заполнено';
									|en = 'The ""Base document description (in genitive case)"" field cannot be blank'");
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, Ссылка,
				"НаименованиеДокументаОснованияВРодительномПадеже", "Объект", Отказ);
			
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(НаименованиеДокументаОснования)
			И Не ЗначениеЗаполнено(НаименованиеДокументаОснованияВРодительномПадеже) Тогда
			
			ТекстСообщения = НСтр("ru = 'Поле ""Документ основание"" не заполнено';
									|en = '""Base document"" is required'");
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, Ссылка,
				"Объект.ДокументОснование", "", Отказ);
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Статья)
		И Не ЗначениеЗаполнено(Часть)
		И Не ЗначениеЗаполнено(Пункт)
		И Не ЗначениеЗаполнено(Подпункт)
		И Не ЗначениеЗаполнено(Абзац) Тогда
		
		ТекстСообщения = НСтр("ru = 'Поля номера текста основания в нормативном документе не заполнены';
								|en = 'Fields of the base text number in the regulatory document cannot be blank'");
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, Ссылка, "Статья", "Объект", Отказ);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.';
						|en = 'Invalid object call on the client.'");
#КонецЕсли