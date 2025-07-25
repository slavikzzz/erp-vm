////////////////////////////////////////////////////////////////////////////////
// Способы выплаты зарплаты.
// Процедуры и функции объекта и менеджера.
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

Функция НовыеОписанияПоставляемых() Экспорт
	Описания = Новый ТаблицаЗначений;
	Описания.Колонки.Добавить("ИмяПредопределенныхДанных", Новый ОписаниеТипов("Строка",, Новый КвалификаторыСтроки(256)));
	Описания.Колонки.Добавить("Наименование", Новый ОписаниеТипов("Строка",, Новый КвалификаторыСтроки(50)));
	Для Каждого Реквизит Из Метаданные.Справочники.СпособыВыплатыЗарплаты.Реквизиты Цикл
		Если СтрНачинаетсяС(Реквизит.Имя, "Удалить") Тогда
			Продолжить;
		КонецЕсли;	
		Описания.Колонки.Добавить(Реквизит.Имя, Реквизит.Тип);
	КонецЦикла;
	Возврат Описания
КонецФункции

Функция ДобавитьОписаниеПоставляемого(Описания) Экспорт
	Описание = Описания.Добавить();
	
	Описание.Поставляемый = Истина;
	Описание.Округление = Справочники.СпособыОкругленияПриРасчетеЗарплаты.ПоУмолчанию();
	Описание.ПроцентВыплаты = 100;
	
	Возврат Описание
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ПервоначальноеЗаполнениеИОбновлениеИнформационнойБазы

/// Обработчики обновления

Процедура НачальноеЗаполнение() Экспорт
	
	Запрос = Новый Запрос;
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	СпособыВыплатыЗарплаты.Ссылка КАК Ссылка,
	|	СпособыВыплатыЗарплаты.ХарактерВыплаты КАК ХарактерВыплаты,
	|	СпособыВыплатыЗарплаты.СпособПолучения КАК СпособПолучения,
	|	СпособыВыплатыЗарплаты.ВидДокументаОснования КАК ВидДокументаОснования,
	|	СпособыВыплатыЗарплаты.ГруппаВидовДоговоров КАК ГруппаВидовДоговоров,
	|	СпособыВыплатыЗарплаты.ОкончательныйРасчетНДФЛ КАК ОкончательныйРасчетНДФЛ
	|ИЗ
	|	Справочник.СпособыВыплатыЗарплаты КАК СпособыВыплатыЗарплаты
	|ГДЕ
	|	СпособыВыплатыЗарплаты.Поставляемый";
				   
	Выборка = Запрос.Выполнить().Выбрать();
	
	СтруктураПоиска = КлючПоставляемых();
	Для Каждого ОписаниеПоставляемого Из ОписанияПоставляемых() Цикл
		
		ЗаполнитьЗначенияСвойств(СтруктураПоиска, ОписаниеПоставляемого);
		
		Выборка.Сбросить();
		Если Выборка.НайтиСледующий(СтруктураПоиска) Тогда
			СпособВыплатыОбъект = Выборка.Ссылка.ПолучитьОбъект();
			СпособВыплатыОбъект.ПометкаУдаления = Ложь;
		Иначе
			Если ЗначениеЗаполнено(ОписаниеПоставляемого.ИмяПредопределенныхДанных) Тогда
				Предопределенный = 
					ОбщегоНазначения.ПредопределенныйЭлемент("Справочник.СпособыВыплатыЗарплаты." + ОписаниеПоставляемого.ИмяПредопределенныхДанных);
				СпособВыплатыОбъект	= Предопределенный.ПолучитьОбъект();
			Иначе	
				СпособВыплатыОбъект = Справочники.СпособыВыплатыЗарплаты.СоздатьЭлемент();
			КонецЕсли	
		КонецЕсли;	
			
		ЗаполнитьЗначенияСвойств(СпособВыплатыОбъект, ОписаниеПоставляемого,, "ИмяПредопределенныхДанных");
		
		СпособВыплатыОбъект.Записать();
			
	КонецЦикла;	
	
КонецПроцедуры

Процедура УстановитьМежрасчетныйПорядокВыплатыПриОкончательномРасчетеПоОснованиям(ПараметрыОбновления = Неопределено) Экспорт 
	
	ОбновлениеИБ = ОбновлениеИнформационнойБазыЗарплатаКадрыБазовый;
	
	Запрос = Новый Запрос;
	// Условие на пустой СпособПолучения нужен на случай, если в отложенном режиме этот обработчик запустится раньше,
	// чем обработчик заполнения реквизита СпособПолучения в БЗКБ.
	// См. Справочники.СпособыВыплатыЗарплаты.ЗаполнитьСпособПолученияЗарплатыКВыплате
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	СпособыВыплатыЗарплаты.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.СпособыВыплатыЗарплаты КАК СпособыВыплатыЗарплаты
	|ГДЕ
	|	(СпособыВыплатыЗарплаты.СпособПолучения = ЗНАЧЕНИЕ(Перечисление.СпособыПолученияЗарплатыКВыплате.ОкончательныйРасчет)
	|			ИЛИ СпособыВыплатыЗарплаты.СпособПолучения = ЗНАЧЕНИЕ(Перечисление.СпособыПолученияЗарплатыКВыплате.ПустаяСсылка))
	|	И СпособыВыплатыЗарплаты.ВидДокументаОснования <> ЗНАЧЕНИЕ(Перечисление.ВидыДокументовОснованийВедомостейНаВыплатуЗарплаты.ПустаяСсылка)
	|	И СпособыВыплатыЗарплаты.ХарактерВыплаты = ЗНАЧЕНИЕ(Перечисление.ХарактерВыплатыЗарплаты.Зарплата)";
	
	ОписаниеБлокировки = ОбновлениеИБ.ОписаниеБлокируемыхДанных(Метаданные.Справочники.СпособыВыплатыЗарплаты);
	
	ОбновляемыеДанные = ОбновлениеИБ.ВыполнитьЗапросПолученияОбновляемыхДанных(Запрос, ПараметрыОбновления);
	
	Если ОбновляемыеДанные.Пустой() Тогда
		ОбновлениеИБ.ЗавершитьОбработчик(ПараметрыОбновления);
		Возврат;
	Иначе
		ОбновлениеИБ.ПродолжитьОбработчик(ПараметрыОбновления);
	КонецЕсли;	

	ВыборкаОбновляемыхДанных = ОбновляемыеДанные.Выбрать();
	Пока ВыборкаОбновляемыхДанных.Следующий() Цикл
		
		ОписаниеБлокировки.ПоляБлокировки.Ссылка = ВыборкаОбновляемыхДанных.Ссылка;
		Если Не ОбновлениеИБ.НачатьОбновлениеДанных(ОписаниеБлокировки, ПараметрыОбновления) Тогда
			Возврат	
		КонецЕсли;
		
		СпособВыплаты = ВыборкаОбновляемыхДанных.Ссылка.ПолучитьОбъект();
		СпособВыплаты.ХарактерВыплаты = Перечисления.ХарактерВыплатыЗарплаты.Межрасчет;
		Если Не ЗначениеЗаполнено(СпособВыплаты.СпособПолучения) Тогда
			СпособВыплаты.СпособПолучения = Перечисления.СпособыПолученияЗарплатыКВыплате.ОкончательныйРасчет;
			СпособВыплаты.ОкончательныйРасчетНДФЛ = Истина;
		КонецЕсли;	
		
		ОбновлениеИнформационнойБазы.ЗаписатьДанные(СпособВыплаты);
		ОбновлениеИБ.ЗавершитьОбновлениеДанных(ПараметрыОбновления);			
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ДобавитьВыплатуНачисленияЗарплаты(ПараметрыОбновления = Неопределено) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	СпособыВыплатыЗарплаты.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.СпособыВыплатыЗарплаты КАК СпособыВыплатыЗарплаты
	|ГДЕ
	|	СпособыВыплатыЗарплаты.ВидДокументаОснования = &НачислениеЗарплаты
	|	И СпособыВыплатыЗарплаты.ХарактерВыплаты = ЗНАЧЕНИЕ(Перечисление.ХарактерВыплатыЗарплаты.Зарплата)
	|	И СпособыВыплатыЗарплаты.Поставляемый";
	Запрос.УстановитьПараметр("НачислениеЗарплаты", Перечисления.ВидыДокументовОснованийВедомостейНаВыплатуЗарплаты.НачислениеЗарплаты);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если РезультатЗапроса.Пустой() Тогда
		
		ПараметрыОтбора = Новый Структура();
		ПараметрыОтбора.Вставить(
			"ВидДокументаОснования", 
			Перечисления.ВидыДокументовОснованийВедомостейНаВыплатуЗарплаты.НачислениеЗарплаты);
		ПараметрыОтбора.Вставить(
			"ХарактерВыплаты", 
			Перечисления.ХарактерВыплатыЗарплаты.Зарплата);
		ОписаниеНачисленияЗарплаты = ОписанияПоставляемых().НайтиСтроки(ПараметрыОтбора)[0];
		
		СпособВыплатыОбъект = Справочники.СпособыВыплатыЗарплаты.СоздатьЭлемент();
		ЗаполнитьЗначенияСвойств(СпособВыплатыОбъект, ОписаниеНачисленияЗарплаты,, "ИмяПредопределенныхДанных");
		
		ОбновлениеИнформационнойБазы.ЗаписатьДанные(СпособВыплатыОбъект);
		
	КонецЕсли
	
КонецПроцедуры

/// Служебные методы

Функция ОписанияПоставляемых()
	
	Описания = НовыеОписанияПоставляемых();
	
	Описание = ДобавитьОписаниеПоставляемого(Описания);
	Описание.Наименование            = НСтр("ru = 'Аванс';
											|en = 'Advance'");
	Описание.ХарактерВыплаты         = Перечисления.ХарактерВыплатыЗарплаты.Аванс;
	Описание.СпособПолучения         = Перечисления.СпособыПолученияЗарплатыКВыплате.Аванс;
	Описание.ГруппаВидовДоговоров    = Перечисления.ГруппыВидовДоговоровССотрудникамиДляВыплатыЗарплаты.Все;
	Описание.ОкончательныйРасчетНДФЛ = Ложь;
	
	Описание = ДобавитьОписаниеПоставляемого(Описания);
	Описание.ИмяПредопределенныхДанных = "Зарплата";
	Описание.Наименование              = НСтр("ru = 'Зарплата за месяц';
												|en = 'Salary per month'");
	Описание.ХарактерВыплаты           = Перечисления.ХарактерВыплатыЗарплаты.Зарплата;
	Описание.СпособПолучения           = Перечисления.СпособыПолученияЗарплатыКВыплате.ОкончательныйРасчет;
	Описание.ГруппаВидовДоговоров      = Перечисления.ГруппыВидовДоговоровССотрудникамиДляВыплатыЗарплаты.Все;
	Описание.ОкончательныйРасчетНДФЛ   = Истина;
	
	Описание = ДобавитьОписаниеПоставляемого(Описания);
	Описание.Наименование            = НСтр("ru = 'Зарплата работников и служащих';
											|en = 'Salary of workers and employees'");
	Описание.ХарактерВыплаты         = Перечисления.ХарактерВыплатыЗарплаты.Зарплата;
	Описание.СпособПолучения         = Перечисления.СпособыПолученияЗарплатыКВыплате.ОкончательныйРасчет;
	Описание.ГруппаВидовДоговоров    = Перечисления.ГруппыВидовДоговоровССотрудникамиДляВыплатыЗарплаты.РаботникиСлужащие;
	Описание.ОкончательныйРасчетНДФЛ = Истина;
	
	Описание = ДобавитьОписаниеПоставляемого(Описания);
	Описание.Наименование            = НСтр("ru = 'Вознаграждение сотрудникам по договорам ГПХ';
											|en = 'Remuneration to employees under civil law contracts'");
	Описание.ХарактерВыплаты         = Перечисления.ХарактерВыплатыЗарплаты.Зарплата;
	Описание.СпособПолучения         = Перечисления.СпособыПолученияЗарплатыКВыплате.ОкончательныйРасчет;
	Описание.ГруппаВидовДоговоров    = Перечисления.ГруппыВидовДоговоровССотрудникамиДляВыплатыЗарплаты.ПоДоговорамГПХ;
	Описание.ОкончательныйРасчетНДФЛ = Истина;
	
	Описание = ДобавитьОписаниеПоставляемого(Описания);
	Описание.Наименование            = НСтр("ru = 'Начисление зарплаты';
											|en = 'Payroll accrual'");
	Описание.ХарактерВыплаты         = Перечисления.ХарактерВыплатыЗарплаты.Зарплата;
	Описание.СпособПолучения         = Перечисления.СпособыПолученияЗарплатыКВыплате.ОкончательныйРасчет;
	Описание.ВидДокументаОснования   = Перечисления.ВидыДокументовОснованийВедомостейНаВыплатуЗарплаты.НачислениеЗарплаты;
	Описание.ГруппаВидовДоговоров    = Перечисления.ГруппыВидовДоговоровССотрудникамиДляВыплатыЗарплаты.Все;
	Описание.ОкончательныйРасчетНДФЛ = Истина;
	
	Описание = ДобавитьОписаниеПоставляемого(Описания);
	Описание.Наименование            = НСтр("ru = 'Отпуска (под расчет)';
											|en = 'Leaves (for calculation)'");
	Описание.ХарактерВыплаты         = Перечисления.ХарактерВыплатыЗарплаты.Межрасчет;
	Описание.СпособПолучения         = Перечисления.СпособыПолученияЗарплатыКВыплате.ОкончательныйРасчет;
	Описание.ВидДокументаОснования   = Перечисления.ВидыДокументовОснованийВедомостейНаВыплатуЗарплаты.Отпуск;
	Описание.ГруппаВидовДоговоров    = Перечисления.ГруппыВидовДоговоровССотрудникамиДляВыплатыЗарплаты.Все;
	Описание.ОкончательныйРасчетНДФЛ = Истина;
     	
	Описание = ДобавитьОписаниеПоставляемого(Описания);
	Описание.Наименование            = НСтр("ru = 'Больничные листы (под расчет)';
											|en = 'Sick leave records (for calculation)'");
	Описание.ХарактерВыплаты         = Перечисления.ХарактерВыплатыЗарплаты.Межрасчет;
	Описание.СпособПолучения         = Перечисления.СпособыПолученияЗарплатыКВыплате.ОкончательныйРасчет;
	Описание.ВидДокументаОснования   = Перечисления.ВидыДокументовОснованийВедомостейНаВыплатуЗарплаты.БольничныйЛист;
	Описание.ГруппаВидовДоговоров    = Перечисления.ГруппыВидовДоговоровССотрудникамиДляВыплатыЗарплаты.Все;
	Описание.ОкончательныйРасчетНДФЛ = Истина;
		
	МежрасчетныеВыплаты = Новый Соответствие;
	МежрасчетныеВыплаты.Вставить(Перечисления.ВидыДокументовОснованийВедомостейНаВыплатуЗарплаты.БольничныйЛист,                    НСтр("ru = 'Больничные листы';
																																		|en = 'Sick leave records'"));
	МежрасчетныеВыплаты.Вставить(Перечисления.ВидыДокументовОснованийВедомостейНаВыплатуЗарплаты.ВозвратНДФЛ,                       НСтр("ru = 'Возврат НДФЛ';
																																		|en = 'PIT return'"));
	МежрасчетныеВыплаты.Вставить(Перечисления.ВидыДокументовОснованийВедомостейНаВыплатуЗарплаты.ЕдиновременноеПособиеЗаСчетФСС,    НСтр("ru = 'Единовременные пособия за счет ФСС';
																																		|en = 'One-time allowances out of SSF funds'"));
	МежрасчетныеВыплаты.Вставить(Перечисления.ВидыДокументовОснованийВедомостейНаВыплатуЗарплаты.Командировка,                      НСтр("ru = 'Командировки';
																																		|en = 'Business trips'"));
	МежрасчетныеВыплаты.Вставить(Перечисления.ВидыДокументовОснованийВедомостейНаВыплатуЗарплаты.КомпенсацияЗаЗадержкуЗарплаты,     НСтр("ru = 'Компенсации за задержку зарплаты';
																																		|en = 'Compensations for late payment of salary'"));
	МежрасчетныеВыплаты.Вставить(Перечисления.ВидыДокументовОснованийВедомостейНаВыплатуЗарплаты.МатериальнаяПомощь,                НСтр("ru = 'Материальная помощь';
																																		|en = 'Support payment'"));
	МежрасчетныеВыплаты.Вставить(Перечисления.ВидыДокументовОснованийВедомостейНаВыплатуЗарплаты.НачислениеЗарплаты,                НСтр("ru = 'Доначисление';
																																		|en = 'Additional accrual '"));
	МежрасчетныеВыплаты.Вставить(Перечисления.ВидыДокументовОснованийВедомостейНаВыплатуЗарплаты.ОплатаДнейУходаЗаДетьмиИнвалидами, НСтр("ru = 'Оплата дней ухода за детьми-инвалидами';
																																		|en = 'Payment for disabled child care days '"));
	МежрасчетныеВыплаты.Вставить(Перечисления.ВидыДокументовОснованийВедомостейНаВыплатуЗарплаты.ОплатаПоСреднемуЗаработку,         НСтр("ru = 'Отсутствие с сохранением оплаты';
																																		|en = 'Paid absence'"));
	МежрасчетныеВыплаты.Вставить(Перечисления.ВидыДокументовОснованийВедомостейНаВыплатуЗарплаты.Отпуск,                            НСтр("ru = 'Отпуска';
																																		|en = 'Leaves'"));
	МежрасчетныеВыплаты.Вставить(Перечисления.ВидыДокументовОснованийВедомостейНаВыплатуЗарплаты.ОтпускПоУходуЗаРебенком,           НСтр("ru = 'Отпуска по уходу за ребенком';
																																		|en = 'Child care leaves'"));
	МежрасчетныеВыплаты.Вставить(Перечисления.ВидыДокументовОснованийВедомостейНаВыплатуЗарплаты.Премия,                            НСтр("ru = 'Премии';
																																		|en = 'Bonuses'"));
	МежрасчетныеВыплаты.Вставить(Перечисления.ВидыДокументовОснованийВедомостейНаВыплатуЗарплаты.ПростойСотрудников,                НСтр("ru = 'Простои';
																																		|en = 'Downtime'"));
	МежрасчетныеВыплаты.Вставить(Перечисления.ВидыДокументовОснованийВедомостейНаВыплатуЗарплаты.РазовоеНачисление,                 НСтр("ru = 'Разовые начисления';
																																		|en = 'One-time accruals'"));
	МежрасчетныеВыплаты.Вставить(Перечисления.ВидыДокументовОснованийВедомостейНаВыплатуЗарплаты.Увольнение,                        НСтр("ru = 'Увольнения';
																																		|en = 'Terminations of employment'"));
	МежрасчетныеВыплаты.Вставить(Перечисления.ВидыДокументовОснованийВедомостейНаВыплатуЗарплаты.НачислениеПоДоговорам,             НСтр("ru = 'Начисления по договорам';
																																		|en = 'Accruals under contracts'"));

	ВидыДокументовСОкончательнымРасчетом = Новый Массив;
	ВидыДокументовСОкончательнымРасчетом.Добавить(Перечисления.ВидыДокументовОснованийВедомостейНаВыплатуЗарплаты.ОтпускПоУходуЗаРебенком);
	ВидыДокументовСОкончательнымРасчетом.Добавить(Перечисления.ВидыДокументовОснованийВедомостейНаВыплатуЗарплаты.Увольнение);
	
	ДоступныеВидыДокументаОснования = Перечисления.ВидыДокументовОснованийВедомостейНаВыплатуЗарплаты.ДоступныеПоМетаданным();	
	Для Каждого МежрасчетнаяВыплата Из МежрасчетныеВыплаты Цикл
		
		Если ДоступныеВидыДокументаОснования.Найти(МежрасчетнаяВыплата.Ключ) = Неопределено Тогда
			Продолжить
		КонецЕсли;
		
		Описание = ДобавитьОписаниеПоставляемого(Описания);
		Описание.Наименование = МежрасчетнаяВыплата.Значение;
		Описание.ХарактерВыплаты = Перечисления.ХарактерВыплатыЗарплаты.Межрасчет;	
		Если ВидыДокументовСОкончательнымРасчетом.Найти(МежрасчетнаяВыплата.Ключ) <> Неопределено Тогда
			Описание.СпособПолучения         = Перечисления.СпособыПолученияЗарплатыКВыплате.ОкончательныйРасчет;
			Описание.ОкончательныйРасчетНДФЛ = Истина;
		Иначе	
			Описание.СпособПолучения         = Перечисления.СпособыПолученияЗарплатыКВыплате.ОтдельныйРасчет;
			Описание.ОкончательныйРасчетНДФЛ = Ложь;
		КонецЕсли;	
		Описание.ВидДокументаОснования   = МежрасчетнаяВыплата.Ключ;
		Описание.ГруппаВидовДоговоров    = Перечисления.ГруппыВидовДоговоровССотрудникамиДляВыплатыЗарплаты.Все;
		
	КонецЦикла;	
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ГосударственнаяСлужба") Тогда 
		Модуль = ОбщегоНазначения.ОбщийМодуль("ГосударственнаяСлужба");
		ОбщегоНазначенияКлиентСервер.ДополнитьТаблицу(
			Модуль.СпособыВыплатыЗарплатыОписанияПоставляемых(), 
			Описания); 
	КонецЕсли;
	
	Возврат Описания;
			
КонецФункции

Функция КлючПоставляемых()
	Возврат Новый Структура("ХарактерВыплаты, СпособПолучения, ВидДокументаОснования, ГруппаВидовДоговоров, ОкончательныйРасчетНДФЛ")
КонецФункции

#КонецОбласти

#Область ОбработчикиСобытийОбъекта

Процедура ОбработкаПроверкиЗаполнения(СпособВыплаты, Отказ, ПроверяемыеРеквизиты) Экспорт
	
	НепроверяемыеРеквизиты = Новый Массив();
	НепроверяемыеРеквизиты.Добавить(Метаданные.Справочники.СпособыВыплатыЗарплаты.Реквизиты.СтатьяРасходов.Имя);
	
	Если ЗначениеЗаполнено(СпособВыплаты.ВидДокументаОснования) Тогда
		
		ДоступныеВидыДокументаОснования = 
			Перечисления.ВидыДокументовОснованийВедомостейНаВыплатуЗарплаты.ДоступныеПоМетаданным();

		Если ДоступныеВидыДокументаОснования.Найти(СпособВыплаты.ВидДокументаОснования) = Неопределено Тогда
			ТекстОшибки = 
				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Документ ""%1"" недоступен в этой конфигурации';
						|en = 'The ""%1"" document is not available in this configuration'"), 
					СпособВыплаты.ВидДокументаОснования);
			ОбщегоНазначения.СообщитьПользователю(
				ТекстОшибки,
				СпособВыплаты.Ссылка, 
				"ВидДокументаОснования",
				, 
				Отказ);
		КонецЕсли;
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, НепроверяемыеРеквизиты);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийМенеджера

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка) Экспорт
	
	СтандартнаяОбработка = Ложь;
	ДанныеВыбора = Новый СписокЗначений;
	
	ДоступныеВидыДокументаОснования = Перечисления.ВидыДокументовОснованийВедомостейНаВыплатуЗарплаты.ДоступныеПоФункциональнымОпциям();
	ДоступныеГруппыВидовДоговоров   = Перечисления.ГруппыВидовДоговоровССотрудникамиДляВыплатыЗарплаты.ДоступныеПоФункциональнымОпциям();
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ДоступныеВидыДокументаОснования", ДоступныеВидыДокументаОснования);
	Запрос.УстановитьПараметр("ДоступныеГруппыВидовДоговоров",   ДоступныеГруппыВидовДоговоров);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	СпособыВыплатыЗарплаты.Ссылка КАК Ссылка,
	|	ВЫБОР
	|		КОГДА СпособыВыплатыЗарплаты.ХарактерВыплаты = ЗНАЧЕНИЕ(Перечисление.ХарактерВыплатыЗарплаты.Зарплата)
	|				И СпособыВыплатыЗарплаты.ВидДокументаОснования = ЗНАЧЕНИЕ(Перечисление.ВидыДокументовОснованийВедомостейНаВыплатуЗарплаты.ПустаяСсылка)
	|			ТОГДА 1
	|		КОГДА СпособыВыплатыЗарплаты.ХарактерВыплаты = ЗНАЧЕНИЕ(Перечисление.ХарактерВыплатыЗарплаты.Аванс)
	|			ТОГДА 2
	|		ИНАЧЕ 3
	|	КОНЕЦ КАК Вес
	|ИЗ
	|	Справочник.СпособыВыплатыЗарплаты КАК СпособыВыплатыЗарплаты
	|ГДЕ
	|	НЕ СпособыВыплатыЗарплаты.ПометкаУдаления
	|	И (СпособыВыплатыЗарплаты.ВидДокументаОснования = ЗНАЧЕНИЕ(Перечисление.ВидыДокументовОснованийВедомостейНаВыплатуЗарплаты.ПустаяСсылка)
	|			ИЛИ СпособыВыплатыЗарплаты.ВидДокументаОснования В (&ДоступныеВидыДокументаОснования))
	|	И (СпособыВыплатыЗарплаты.ГруппаВидовДоговоров = ЗНАЧЕНИЕ(Перечисление.ГруппыВидовДоговоровССотрудникамиДляВыплатыЗарплаты.ПустаяСсылка)
	|			ИЛИ СпособыВыплатыЗарплаты.ГруппаВидовДоговоров В (&ДоступныеГруппыВидовДоговоров))
	|	И &ПараметрыОтбора
	|
	|УПОРЯДОЧИТЬ ПО
	|	Вес,
	|	СпособыВыплатыЗарплаты.Наименование";
	
	УсловияОтбора = Новый Массив;
	Для Каждого ЭлементОтбора Из Параметры.Отбор Цикл
		ИмяПараметра = "Отбор" + ЭлементОтбора.Ключ;
		Запрос.УстановитьПараметр(ИмяПараметра, ЭлементОтбора.Значение);
		Если ТипЗнч(ЭлементОтбора.Значение) = Тип("ФиксированныйМассив") Тогда
			УсловияОтбора.Добавить(СтрШаблон("СпособыВыплатыЗарплаты.%1 В (&%2)", ЭлементОтбора.Ключ, ИмяПараметра));
		Иначе
			УсловияОтбора.Добавить(СтрШаблон("СпособыВыплатыЗарплаты.%1 = &%2", ЭлементОтбора.Ключ, ИмяПараметра));
		КонецЕсли; 
	КонецЦикла;
	Если УсловияОтбора.Количество() = 0 Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&ПараметрыОтбора", "ИСТИНА");
	Иначе	
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&ПараметрыОтбора", СтрСоединить(УсловияОтбора, " И "));
	КонецЕсли;	
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		ДанныеВыбора.Добавить(Выборка.Ссылка);
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти


#КонецОбласти
