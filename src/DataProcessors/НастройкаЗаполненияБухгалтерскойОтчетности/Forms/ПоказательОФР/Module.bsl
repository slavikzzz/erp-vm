#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, Параметры, "Показатель, НаименованиеПоказателя, ГруппыПоказателей, ЗачетПоказателей");
	
	Если ЗачетПоказателей = "Показатель" Тогда
		ТекущийЭлемент = Элементы.ЗачетПоказателейПоказатель;
	ИначеЕсли ЗачетПоказателей = "СтатьиОбъекты" Тогда
		ТекущийЭлемент = Элементы.ЗачетПоказателейСтатьиОбъекты;
	КонецЕсли;
	
	// Презюмируем, что доходы в отчете предшествуют расходам
	Для Каждого ГруппаПоказателя Из ГруппыПоказателей Цикл
		
		НомерСтроки = ГруппыПоказателей.Индекс(ГруппаПоказателя) + 1; // Используем номер, а не индекс или идентификатор, чтобы значение по умолчанию заведомо соответствовало не заполненному
		
		Элементы.ГруппаДоходы.СписокВыбора.Добавить(НомерСтроки,  ГруппаПоказателя.Представление);
		Элементы.ГруппаРасходы.СписокВыбора.Добавить(НомерСтроки, ГруппаПоказателя.Представление);
		
		Если ГруппаПоказателя.Пометка Тогда
			
			Если ГруппаДоходы = 0 Тогда
				ГруппаДоходы = НомерСтроки;
			ИначеЕсли ГруппаРасходы = 0 Тогда
				ГруппаРасходы = НомерСтроки;
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Если Не ЗначениеЗаполнено(ГруппыПоказателей) Тогда
		Возврат;
	КонецЕсли;
	
	Если ГруппаРасходы = 0 Тогда
		ГруппаРасходы = ГруппаДоходы;
	КонецЕсли;
	
	НастроитьГруппыДоходовРасходов(Элементы.ГруппаДоходы, Элементы.ГруппаРасходы, Элементы.ГруппыДоходовРасходов, ЗачетПоказателей);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ЗачетПоказателейПриИзменении(Элемент)
	
	НастроитьГруппыДоходовРасходов(Элементы.ГруппаДоходы, Элементы.ГруппаРасходы, Элементы.ГруппыДоходовРасходов, ЗачетПоказателей);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаОК(Команда)
	
	Если Не ПроверитьРезультат() Тогда
		Возврат;
	КонецЕсли;
	
	Результат = Новый Структура;
	Результат.Вставить("ЗачетПоказателей", ЗачетПоказателей);
	Результат.Вставить("Группы",           Новый Соответствие);
	
	Если ГруппаДоходы > 0 Тогда
		Результат.Группы.Вставить(ГруппыПоказателей[ГруппаДоходы - 1].Значение, Истина);
	КонецЕсли;
	
	Если ГруппаРасходы > 0 Тогда
		Результат.Группы.Вставить(ГруппыПоказателей[ГруппаРасходы - 1].Значение, Истина);
	КонецЕсли;
	
	Закрыть(Результат);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Функция ПроверитьРезультат()
	
	Ошибка = "";
	
	Если ЗачетПоказателей <> "Показатель" Тогда
		
		ОшибкаЗаполненыГруппы = Новый Массив;
		Если ГруппаДоходы = 0 И ГруппаРасходы = 0 Тогда
			ОшибкаЗаполненыГруппы.Добавить(НСтр("ru = 'Не заполнены группы доходов и расходов.';
												|en = 'Не заполнены группы доходов и расходов.'"));
		ИначеЕсли ГруппаДоходы = 0 Тогда
			ОшибкаЗаполненыГруппы.Добавить(НСтр("ru = 'Не заполнена группа доходов.';
												|en = 'Не заполнена группа доходов.'"));
		ИначеЕсли ГруппаРасходы = 0 Тогда
			ОшибкаЗаполненыГруппы.Добавить(НСтр("ru = 'Не заполнена группа расходов.';
												|en = 'Не заполнена группа расходов.'"));
		ИначеЕсли ГруппаДоходы = ГруппаРасходы Тогда
			ОшибкаЗаполненыГруппы.Добавить(НСтр("ru = 'Указана одна и та же группа для доходов и расходов.';
												|en = 'Указана одна и та же группа для доходов и расходов.'"));
		КонецЕсли;
		Если ЗначениеЗаполнено(ОшибкаЗаполненыГруппы) Тогда
			ОшибкаЗаполненыГруппы.Добавить(
				НСтр("ru = 'Если доходы и расходы не зачитываются по показателю в целом, то следует указать группу, в которую будет включена строка с доходами и группу, в которую будет включена строка с расходами.';
					|en = 'Если доходы и расходы не зачитываются по показателю в целом, то следует указать группу, в которую будет включена строка с доходами и группу, в которую будет включена строка с расходами.'"));
        	Ошибка = СтрСоединить(ОшибкаЗаполненыГруппы, Символы.ПС + Символы.ПС);
		КонецЕсли;
			
	КонецЕсли;
	
	Если ПустаяСтрока(Ошибка) Тогда
		
		Если ГруппаДоходы > ГруппаРасходы Тогда
			ДопустимыеГруппыРасходов = НСтр("ru = 'одну из групп, следующих за группой доходов';
											|en = 'одну из групп, следующих за группой доходов'");
			Если ЗачетПоказателей = "Показатель" Тогда
				ДопустимыеГруппыРасходов = НСтр("ru = 'одну из групп, следующих за группой доходов, или совпадающую с группой доходов';
												|en = 'одну из групп, следующих за группой доходов, или совпадающую с группой доходов'");
			КонецЕсли;
			Ошибка = СтрШаблон(НСтр("ru = 'Группы доходов и расходов указаны в неверном порядке.
                          |
                          |В качестве группы расходов следует указать %1.';
                          |en = 'Группы доходов и расходов указаны в неверном порядке.
                          |
                          |В качестве группы расходов следует указать %1.'"), ДопустимыеГруппыРасходов);
		КонецЕсли;
		
	КонецЕсли;
	
	Если Не ПустаяСтрока(Ошибка) Тогда
		
		ПоказатьПредупреждение(, Ошибка);
		Возврат Ложь;
		
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура НастроитьГруппыДоходовРасходов(ГруппаДоходы, ГруппаРасходы, ГруппыДоходовРасходов, ЗачетПоказателей)
	
	Перем ОписаниеЗачета, ШаблонПодсказки;
	
	Если ЗачетПоказателей = "Показатель" Тогда
		
		ГруппаДоходы.Заголовок  = НСтр("ru = 'Группа с доходом';
										|en = 'Группа с доходом'");
		ГруппаРасходы.Заголовок = НСтр("ru = 'Группа с расходом';
										|en = 'Группа с расходом'");
		ГруппыДоходовРасходов.Подсказка = НСтр("ru = 'Когда доходы и расходы зачитываются по показателю в целом, то в конкретном отчете может быть отражен либо только доход, либо только расход.
                                               |Разные группы может быть уместным указать на случай, если в разных отчетах (например, за разные периоды) может быть когда-то доход, а когда-то расход.';
                                               |en = 'Когда доходы и расходы зачитываются по показателю в целом, то в конкретном отчете может быть отражен либо только доход, либо только расход.
                                               |Разные группы может быть уместным указать на случай, если в разных отчетах (например, за разные периоды) может быть когда-то доход, а когда-то расход.'");
		
		ГруппаДоходы.АвтоотметкаНезаполненного = Ложь;
		ГруппаДоходы.ОтметкаНезаполненного = Ложь;
		
		ГруппаРасходы.АвтоотметкаНезаполненного = Ложь;
		ГруппаРасходы.ОтметкаНезаполненного = Ложь;
		
	Иначе
		
		ГруппаДоходы.Заголовок  = НСтр("ru = 'Группа с доходами';
										|en = 'Группа с доходами'");
		ГруппаРасходы.Заголовок = НСтр("ru = 'Группа с расходами';
										|en = 'Группа с расходами'");
		
		ШаблонПодсказки = НСтр("ru = 'Так как %1, то в отчете могут быть отражены одновременно и доходы и расходы: в одной строке доходы, в другой - расходы.
                                |Доходы и расходы указываются в строках разных групп.';
                                |en = 'Так как %1, то в отчете могут быть отражены одновременно и доходы и расходы: в одной строке доходы, в другой - расходы.
                                |Доходы и расходы указываются в строках разных групп.'");
		
		ОписаниеЗачета = НСтр("ru = 'не все доходы и расходы по показателю зачитываются';
								|en = 'не все доходы и расходы по показателю зачитываются'");
		
		Если ЗачетПоказателей = "Нет" Тогда
			ОписаниеЗачета = НСтр("ru = 'доходы и расходы не зачитываются';
									|en = 'доходы и расходы не зачитываются'");
		КонецЕсли;
		ГруппыДоходовРасходов.Подсказка = СтрШаблон(ШаблонПодсказки, ОписаниеЗачета);
		
		ГруппаДоходы.АвтоотметкаНезаполненного = Истина;
		ГруппаРасходы.АвтоотметкаНезаполненного = Истина;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

