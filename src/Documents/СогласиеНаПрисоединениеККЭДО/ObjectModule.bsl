#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
		
	Если ПометкаУдаления Тогда
		КадровыйЭДОВызовСервера.РазблокироватьФормуОбъекта(Ссылка);
	ИначеЕсли ЕстьДругоеСогласие() Тогда
		Отказ = Истина;
		ОбщегоНазначения.СообщитьПользователю(НСтр("ru = 'По данной организации и сотруднику уже имеется актуальный документ согласия.';
													|en = 'The relevant consent document already exists for this company and employee.'"));
		Возврат;
	КонецЕсли; 
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;

	Если Не ЗначениеЗаполнено(Организация) Или Не ЗначениеЗаполнено(ФизическоеЛицо) Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ПометкаУдаления Тогда
		СформироватьПечатнуюФормуСогласия();
	КонецЕсли;
	
	Если Не ДополнительныеСвойства.Свойство("НеВычислятьПрисоединениеККЭДО") Тогда
		
		ФизическиеЛица = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ФизическоеЛицо);
		РегистрыСведений.ФизическиеЛицаПрисоединенныеККЭДО.УстановитьПодключенККЭДОДляФизическогоЛица(ФизическиеЛица);
		
		МенеджерЗаписиСостояниеСогласия = РегистрыСведений.СостояниеСогласияНаПрисоединениеККЭДО.СоздатьМенеджерЗаписи();
		МенеджерЗаписиСостояниеСогласия.Ссылка = Ссылка;
		МенеджерЗаписиСостояниеСогласия.Прочитать();
		Если Не ЗначениеЗаполнено(МенеджерЗаписиСостояниеСогласия.ДатаНачала) Тогда
			МенеджерЗаписиСостояниеСогласия.Ссылка = Ссылка;
			МенеджерЗаписиСостояниеСогласия.ДатаНачала = Дата;
			МенеджерЗаписиСостояниеСогласия.Записать(Истина);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередУдалением(Отказ)
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	НаборЗаписей = РегистрыСведений.СостояниеСогласияНаПрисоединениеККЭДО.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Ссылка.Установить(Ссылка);
	НаборЗаписей.Записать(Истина);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ЕстьДругоеСогласие()
	
	Запрос = Новый Запрос();
	
	Запрос.Текст = "ВЫБРАТЬ
	               |	СогласиеНаПрисоединениеККЭДО.Ссылка КАК Ссылка
	               |ИЗ
	               |	Документ.СогласиеНаПрисоединениеККЭДО КАК СогласиеНаПрисоединениеККЭДО
	               |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СостояниеСогласияНаПрисоединениеККЭДО КАК СостояниеСогласияНаПрисоединениеККЭДО
	               |		ПО (СостояниеСогласияНаПрисоединениеККЭДО.Ссылка = СогласиеНаПрисоединениеККЭДО.Ссылка)
	               |ГДЕ
	               |	СогласиеНаПрисоединениеККЭДО.ПометкаУдаления = ЛОЖЬ
	               |	И СогласиеНаПрисоединениеККЭДО.Ссылка <> &Ссылка
	               |	И СогласиеНаПрисоединениеККЭДО.ФизическоеЛицо = &ФизическоеЛицо
	               |	И СогласиеНаПрисоединениеККЭДО.Организация = &Организация
	               |	И (СостояниеСогласияНаПрисоединениеККЭДО.ДатаОкончания = ДАТАВРЕМЯ(1, 1, 1, 0, 0, 0)
	               |			ИЛИ СостояниеСогласияНаПрисоединениеККЭДО.ДатаОкончания ЕСТЬ NULL)";
	
	Запрос.УстановитьПараметр("ФизическоеЛицо", ФизическоеЛицо);
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	Возврат Не Запрос.Выполнить().Пустой();
	
КонецФункции

Процедура СформироватьПечатнуюФормуСогласия()
	
	Если Не ЭтоНовый() И ЗначениеЗаполнено(ДокументКЭДОПечатнойФормы()) Тогда
		Возврат;			
	КонецЕсли;
	
	ПечатнаяФорма = Документы.СогласиеНаПрисоединениеККЭДО.ПечатьСогласияНаПрисоединениеККЭДО(
		ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Ссылка),
		Новый СписокЗначений);
	ДанныеПечатнойФормы = КадровыйЭДОВызовСервера.ДобавитьПечатнуюФорму(
		ПечатнаяФорма,
		Ссылка,
		Документы.СогласиеНаПрисоединениеККЭДО.ИдентификаторКомандыПечатиЗаявления(),
		НазваниеПечатнойФормыСогласие(),
		Организация,
		ФизическоеЛицо,
		,
		Истина);
	
КонецПроцедуры

Функция ДокументКЭДОПечатнойФормы()
	
	Запрос = Новый Запрос();
	
	Запрос.Текст = "ВЫБРАТЬ
	               |	ДокументКадровогоЭДО.Ссылка КАК Ссылка
	               |ИЗ
	               |	Документ.ДокументКадровогоЭДО КАК ДокументКадровогоЭДО
	               |ГДЕ
	               |	ДокументКадровогоЭДО.ОснованиеДокумента = &ОснованиеДокумента
	               |	И ДокументКадровогоЭДО.ПометкаУдаления = ЛОЖЬ";
	
	Запрос.УстановитьПараметр("ОснованиеДокумента", Ссылка);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Возврат Выборка.Ссылка;	
	КонецЕсли;
	
	Возврат Неопределено;
		
КонецФункции

Функция НазваниеПечатнойФормыСогласие()
	
	ШаблонНазвания = НСтр("ru = '%1 Согласие на присоединение к КЭДО %2 %3';
							|en = '%1 Consent to join HR EDI %2%3'");
	ФИО = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ФизическоеЛицо, "ФИО");
	ФамилияИнициалы = "";
	Попытка
		ФамилияИнициалы = ФизическиеЛицаЗарплатаКадрыКлиентСервер.ФамилияИнициалы(ФИО);
	Исключение
		ФамилияИнициалы = Строка(ФизическоеЛицо);
	КонецПопытки;
	
	Возврат СтрШаблон(ШаблонНазвания,
					  СокрЛП(ФамилияИнициалы),
					  СокрЛП(Строка(Номер)),
					  СокрЛП(Формат(Дата, "ДФ=yyyyMMdd")));
					  
КонецФункции

#КонецОбласти
	
#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.';
						|en = 'Invalid object call on the client.'");
#КонецЕсли